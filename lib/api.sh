# Object
# [object]
#   meta/
#     class
#     length
#     iterators/
#       default
#     _hist
#   data/
#     string: string-data
#     0/
#       data: list-item-1-data
#     md5(key)/
#        key: hash-key-data
#        val: hash-val-data
#
#
######################################################################
#<
#
# Function: p6_obj__debug(msg)
#
#  Args:
#	msg - 
#
#>
######################################################################
p6_obj__debug() {
  local msg="$1"

  p6_debug "p6_obj: $msg"

  p6_return_void
}

######################################################################
#<
#
# Function: obj obj = p6_obj_create([class=obj], [max_objs=])
#
#  Args:
#	OPTIONAL class -  [obj]
#	OPTIONAL max_objs -  []
#
#  Returns:
#	obj - obj
#
#>
######################################################################
p6_obj_create() {
  local class="${1:-obj}"
  local max_objs="${2:-}"

  local obj=$(p6_store_create "objs/$class" "$max_objs")
  p6_obj__meta_init "$obj" "$class"
  p6_obj__data_init "$obj"

  p6_return_obj "$obj"
}

######################################################################
#<
#
# Function: obj copy = p6_obj_copy(obj)
#
#  Args:
#	obj - 
#
#  Returns:
#	obj - copy
#
#>
######################################################################
p6_obj_copy() {
  local obj="$1"

  local class=$(p6_obj_class "$obj")

  local copy=$(p6_obj_create "$class")

  p6_store_copy "$obj" "$copy"

  p6_return_obj "$copy"
}

######################################################################
#<
#
# Function: p6_obj_destroy(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_destroy() {
  local obj="$1"

  p6_store_destroy "$obj"

  p6_return_void
}

######################################################################
#<
#
# Function: size_t rc = p6_obj_compare(a, b)
#
#  Args:
#	a - 
#	b - 
#
#  Returns:
#	size_t - rc
#
#>
######################################################################
p6_obj_compare() {
  local a="$1"
  local b="$2"

  local rc=$(p6_obj__dispatch "$a" "compare" "$b")

  p6_return_size_t "$rc"
}

######################################################################
#<
#
# Function: obj obj = p6_obj_assign(obj)
#
#  Args:
#	obj - 
#
#  Returns:
#	obj - obj
#
#>
######################################################################
p6_obj_assign() {
  local obj="$1"

  p6_return_obj "$obj"
}

######################################################################
#<
#
# Function: p6_obj_display(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_display() {
  local obj="$1"

  p6_obj__dispatch "$obj" "display"

  p6_return_void
}

######################################################################
#<
#
# Function: code rc = p6_obj_is(obj)
#
#  Args:
#	obj - 
#
#  Returns:
#	code - rc
#
#>
######################################################################
p6_obj_is() {
    local obj="$1"

    p6_dir_exists "$obj"
    local rc=$?

    p6_return_code_as_code "$rc"
}

######################################################################
#<
#
# Function: p6_obj_item_get(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_item_get() {
  local obj="$1"
  shift 1

  p6_obj__dispatch "$obj" "item_get" "$@"
}

######################################################################
#<
#
# Function: str old_val = p6_obj_item_set(obj)
#
#  Args:
#	obj - 
#
#  Returns:
#	str - old_val
#
#>
######################################################################
p6_obj_item_set() {
  local obj="$1"
  shift 1

  local length=$(p6_obj_length "$obj")
  local old_val=$(p6_obj__dispatch "$obj" "item_set" "$@")
  p6_obj_length "$obj" "$(($length+1))"

  p6_return_str "$old_val"
}

######################################################################
#<
#
# Function: p6_obj_item_add(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_item_add() {
  local obj="$1"
  shift 1

  p6_obj__dispatch "$obj" "item_add" "$@"
}

######################################################################
#<
#
# Function: p6_obj_item_delete(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_item_delete() {
  local obj="$1"
  shift 1

  p6_obj__dispatch "$obj" "item_delete" "$@"
}

######################################################################
#<
#
# Function: size_t index = p6_obj_iter_index(obj, [var=default])
#
#  Args:
#	obj - 
#	OPTIONAL var -  [default]
#
#  Returns:
#	size_t - index
#
#>
######################################################################
p6_obj_iter_index() {
  local obj="$1"
  local var="${2:-default}"

  if ! p6_store_iter_exists "$obj" "$var"; then
      p6_store_iter_create "$obj" "$var"
  fi

  p6_obj__debug "iter_index(): [obj=$obj] [var=$var]"
  local index=$(p6_store_iter_current "$obj" "$var")
  p6_obj__debug "iter_index():  -> [index=$index]"

  p6_return_size_t "$index"
}

######################################################################
#<
#
# Function: code rc = p6_obj_iter_more(obj, [var=default])
#
#  Args:
#	obj - 
#	OPTIONAL var -  [default]
#
#  Returns:
#	code - rc
#
#>
######################################################################
p6_obj_iter_more() {
  local obj="$1"
  local var="${2:-default}"

  if ! p6_store_iter_exists "$obj" "$var"; then
    p6_store_iter_create "$obj" "$var"
  fi

  local index=$(p6_obj_iter_index "$obj" "$var")
  local len=$(p6_obj_length "$obj")

  p6_math_lt "$index" "$len"
  local rc=$?

  if [ $rc -ne 0 ]; then
    p6_store_iter_destroy "$obj" "$var"
  fi

  p6_obj__debug "iter_more(): [var=$var] [index=$index] [len=$len] -> [rc=$rc]"

  p6_return_code_as_code "$rc"
}

######################################################################
#<
#
# Function: item item = p6_obj_iter_i(obj, [var=default], i)
#
#  Args:
#	obj - 
#	OPTIONAL var -  [default]
#	i - 
#
#  Returns:
#	item - item
#
#>
######################################################################
p6_obj_iter_i() {
  local obj="$1"
  local var="${2:-default}"
  local i="$3"

  p6_obj__debug "iter_i(): [obj=$obj] [var=$var] [i=$i]"
  local item=$(p6_obj__dispatch "$obj" "iter_i" "$var" "$i")
  p6_obj__debug "iter_i(): -> [item=$item]"

  p6_return_item "$item"
}

######################################################################
#<
#
# Function: item item = p6_obj_iter_current(obj, [var=default])
#
#  Args:
#	obj - 
#	OPTIONAL var -  [default]
#
#  Returns:
#	item - item
#
#>
######################################################################
p6_obj_iter_current() {
  local obj="$1"
  local var="${2:-default}"

  p6_obj__debug "iter_current(): [obj=$obj] [var=$var]"

  local index=$(p6_obj_iter_index "$obj" "$var")
  p6_obj__debug "iter_current(): [index=$index]"

  local item=$(p6_obj_iter_i "$obj" "$var" "$index")
  p6_obj__debug "iter_current(): [item=$item]"

  p6_return_item "$item"
}

######################################################################
#<
#
# Function: p6_obj_iter_ate(obj, [var=default], [move=1])
#
#  Args:
#	obj - 
#	OPTIONAL var -  [default]
#	OPTIONAL move -  [1]
#
#>
######################################################################
p6_obj_iter_ate() {
  local obj="$1"
  local var="${2:-default}"
  local move="${3:-1}"

  p6_store_iter_move "$obj" "$var" "$move"

  p6_return_void
}

######################################################################
#<
#
# Function: p6_obj_iter_foreach(obj, var, callback, [filter_callback=])
#
#  Args:
#	obj - 
#	var - 
#	callback - 
#	OPTIONAL filter_callback -  []
#
#>
######################################################################
p6_obj_iter_foreach() {
    local obj="$1"
    local var="$2"
    local callback="$3"
    local filter_callback="${4:-}"
    shift 4

    p6_obj__debug "foreach(): [obj=$obj] [var=$var] [callback=$callback]"
    while p6_obj_iter_more "$obj" "$var"; do
	local item=$(p6_obj_iter_current "$obj" "$var")

	local key=$(p6_obj_item_key "$item")
	local val=$(p6_obj_item_value "$item")

	local func="$callback"
	func=$(echo "$func" | sed -e "s,%%key%%,$key,g")

        if ! p6_string_blank "$filter_callback"; then
    	    if p6_run_code "$filter_callback \"$key\""; then
	        p6_run_yield "$func" "$val"
	    fi
        fi

	p6_obj_iter_ate "$obj" "$var"
    done

    p6_return_void
}

######################################################################
#<
#
# Function: str key = p6_obj_item_key(item)
#
#  Args:
#	item - 
#
#  Returns:
#	str - key
#
#>
######################################################################
p6_obj_item_key() {
    local item="$1"

    # XXX: hack
    local key_file="$item/key"
    local key=$(p6_file_display "$key_file")

    p6_obj__debug "item_key(): [item=$item] [key=$key]"

    p6_return_str "$key"
}

######################################################################
#<
#
# Function: str val = p6_obj_item_value(item)
#
#  Args:
#	item - 
#
#  Returns:
#	str - val
#
#>
######################################################################
p6_obj_item_value() {
    local item="$1"

    # XXX: hack
    local val_file="$item/value"
    local val=$(p6_file_display "$val_file")

    p6_obj__debug "item_value(): [item=$item] [val=$val]"

    p6_return_str "$val"
}

######################################################################
#<
#
# Function: str old_class = p6_obj_class(obj, new)
#
#  Args:
#	obj - 
#	new - 
#
#  Returns:
#	str - old_class
#
#>
######################################################################
p6_obj_class() {
  local obj="$1"
  local new="$2"

  local meta_key=$(p6_obj__meta__key)

  local old_class
  if ! p6_string_blank "$new"; then
    old_class=$(p6_store_hash_set "$obj" "$meta_key" "class" "$new")
  else
    old_class=$(p6_store_hash_get "$obj" "$meta_key" "class")
  fi

  p6_return_str "$old_class"
}

######################################################################
#<
#
# Function: size_t old_length = p6_obj_length(obj, new)
#
#  Args:
#	obj - 
#	new - 
#
#  Returns:
#	size_t - old_length
#
#>
######################################################################
p6_obj_length() {
  local obj="$1"
  local new="$2"

  local meta_key=$(p6_obj__meta__key)

  local old_length
  if ! p6_string_blank "$new"; then
      old_length=$(p6_store_hash_set "$obj" "$meta_key" "length" "$new")
  else
      old_length=$(p6_store_hash_get "$obj" "$meta_key" "length")
  fi

  p6_return_size_t "$old_length"
}

######################################################################
#<
#
# Function: obj rlist = p6_obj_grep(obj, pattern)
#
#  Args:
#	obj - 
#	pattern - 
#
#  Returns:
#	obj - rlist
#
#>
######################################################################
p6_obj_grep() {
  local obj="$1"
  local pattern="$2"

  local rlist=$(p6_obj__dispatch "$obj" "grep" "$pattern")

  p6_return_obj_list "$rlist"
}

######################################################################
#<
#
# Function: p6_obj_reverse(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_reverse() {
  local obj="$1"

  p6_obj__dispatch "$obj" "reverse"

  p6_return_void
}

######################################################################
#<
#
# Function: p6_obj_splice(obj, start, new)
#
#  Args:
#	obj - 
#	start - 
#	new - 
#
#>
######################################################################
p6_obj_splice() {
  local obj="$1"
  local start="$2"
  local new="$3"

  p6_obj__dispatch "$obj" "splice" "$start" "$new"

  p6_return_void
}

######################################################################
#<
#
# Function: p6_obj_trim(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_trim() {
  local obj="$1"

  p6_obj__dispatch "$obj" "trim"

  p6_return_void
}

######################################################################
#<
#
# Function: p6_obj_lc(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_lc() {
  local obj="$1"

  p6_obj__dispatch "$obj" "lc"

  p6_return_void
}

######################################################################
#<
#
# Function: p6_obj_uc(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_uc() {
  local obj="$1"

  p6_obj__dispatch "$obj" "uc"

  p6_return_void
}

######################################################################
#<
#
# Function: p6_obj__meta_init(obj, class)
#
#  Args:
#	obj - 
#	class - 
#
#>
######################################################################
p6_obj__meta_init() {
  local obj="$1"
  local class="$2"

  local meta_key=$(p6_obj__meta__key)

  p6_store_hash_create "$obj" "iterators"

  p6_store_hash_create "$obj" "$meta_key"
  local old_class=$(p6_store_hash_set "$obj" "$meta_key" "class" "$class")
  local old_length=$(p6_store_hash_set "$obj" "$meta_key" "length" "0")

  p6_return_void
}

######################################################################
#<
#
# Function: p6_obj__data_init(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj__data_init() {
  local obj="$1"

  local data_key=$(p6_obj__data__key)

  p6_store_hash_create "$obj" "$data_key"

  p6_return_void
}

######################################################################
#<
#
# Function: p6_obj__dispatch(obj, method)
#
#  Args:
#	obj - 
#	method - 
#
#>
######################################################################
p6_obj__dispatch() {
  local obj="$1"
  local method="$2"
  shift 2

  if ! p6_obj_is "$obj"; then
      p6_return_void
  else
      local class=$(p6_obj_class "$obj")

      p6_obj__debug "__dispatch(): [class=$class] [obj=$obj] [method=$method] [$*]"
      p6_store_${class}_${method} "$obj" "$@"
  fi
}

######################################################################
#<
#
# Function: str meta = p6_obj__meta__key()
#
#  Returns:
#	str - meta
#
#>
######################################################################
p6_obj__meta__key() {

    p6_return_str "meta"
}

######################################################################
#<
#
# Function: str data = p6_obj__data__key()
#
#  Returns:
#	str - data
#
#>
######################################################################
p6_obj__data__key() {

    p6_return_str "data"
}