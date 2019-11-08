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
# Function:
#	p6_obj__debug(msg)
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
# Function:
#	p6_obj_create(class, [max_objs=4])
#
#  Args:
#	class - 
#	OPTIONAL max_objs -  [4]
#
#>
######################################################################
p6_obj_create() {
  local class="$1"
  local max_objs="${2:-4}"

  local obj=$(p6_store_create "objs/$class" "$max_objs")
  p6_obj__meta_init "$obj" "$class"
  p6_obj__data_init "$obj"

  p6_return_obj "$obj"
}

######################################################################
#<
#
# Function:
#	p6_obj_copy(obj)
#
#  Args:
#	obj - 
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
# Function:
#	p6_obj_destroy(obj)
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
# Function:
#	size_t rc = p6_obj_compare()
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
# Function:
#	p6_obj_assign(obj)
#
#  Args:
#	obj - 
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
# Function:
#	p6_obj_display(obj)
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
# Function:
#	p6_obj_item_get(obj)
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
# Function:
#	p6_obj_item_set(obj)
#
#  Args:
#	obj - 
#
#>
######################################################################
p6_obj_item_set() {
  local obj="$1"
  shift 1

  p6_obj__dispatch "$obj" "item_set" "$@"
}

######################################################################
#<
#
# Function:
#	p6_obj_item_add(obj)
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
# Function:
#	p6_obj_item_delete(obj)
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
# Function:
#	size_t index = p6_obj_iter_index(obj, [var=default])
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

  local index=$(p6_iter_current "$obj" "$var")

  p6_return_size_t "$index"
}

######################################################################
#<
#
# Function:
#	bool ool = p6_obj_iter_more(obj, [var=default])
#
#  Args:
#	obj - 
#	OPTIONAL var -  [default]
#
#  Returns:
#	bool - ool
#
#>
######################################################################
p6_obj_iter_more() {
  local obj="$1"
  local var="${2:-default}"

  if ! p6_iter_exists "$obj" "$var"; then
    p6_iter_create "$obj" "$var"
  fi

  local index=$(p6_obj_iter_index "$obj" "$var")
  local len=$(p6_obj_length "$obj")

  local bool=$(p6_math_le "$index" "$len")

  if ! $bool; then
    p6_iter_destroy "$obj" "$var"
  fi

  p6_obj__debug "iter_more(): [var=$var] [index=$index] [len=$len] -> [bool=$bool]"

  p6_return_bool "$ool"
}

######################################################################
#<
#
# Function:
#	p6_obj_iter_i(obj, [var=default])
#
#  Args:
#	obj - 
#	OPTIONAL var -  [default]
#
#>
######################################################################
p6_obj_iter_i() {
  local obj="$1"
  local var="${2:-default}"
  local i="$3"

  local item=$(p6_obj__dispatch "$obj" "iter_i" "$var" "$i")

  p6_return_item "$item"
}

######################################################################
#<
#
# Function:
#	p6_obj_iter_current(obj, [var=default])
#
#  Args:
#	obj - 
#	OPTIONAL var -  [default]
#
#>
######################################################################
p6_obj_iter_current() {
  local obj="$1"
  local var="${2:-default}"

  local index=$(p6_obj_iter_index "$obj" "$var")
  local item=$(p6_obj_iter_i "$obj" "$var" "$index")

  p6_return_item "$item"
}

######################################################################
#<
#
# Function:
#	p6_obj_iter_ate(obj, [var=default], [move=1])
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

  p6_iter_move "$obj" "$var" "$move"

  p6_return_void
}

######################################################################
#<
#
# Function:
#	p6_obj_iter_foreach(obj, var, callback)
#
#  Args:
#	obj - 
#	var - 
#	callback - 
#
#>
######################################################################
p6_obj_iter_foreach() {
    local obj="$1"
    local var="$2"
    local callback="$3"
    shift 3

    p6_obj__debug "foreach(): [obj=$obj] [var=$var] [callback=$callback]"
    while p6_obj_iter_more "$obj"; do
	local item=$(p6_obj_iter_current "$obj")

	p6_yield "$callback" "$obj" "$item"

	p6_obj_iter_ate "$obj"
    done

    p6_return_void
}

######################################################################
#<
#
# Function:
#	str old_class = p6_obj_class(obj, new)
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

  if ! p6_string_blank "$new"; then
      local old_class=$(p6_store_hash_set "$obj" "$meta_key" "class" "$new")
  fi

  p6_return_str "$old_class"
}

######################################################################
#<
#
# Function:
#	size_t length = p6_obj_length(obj)
#
#  Args:
#	obj - 
#
#  Returns:
#	size_t - length
#
#>
######################################################################
p6_obj_length() {
  local obj="$1"

  local meta_key=$(p6_obj__meta__key)

  local length=$(p6_store_hash_get "$obj" "$meta_key" "length")

  p6_return_size_t "$length"
}

######################################################################
#<
#
# Function:
#	p6_obj_grep(obj, pattern)
#
#  Args:
#	obj - 
#	pattern - 
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
# Function:
#	p6_obj_reverse(obj)
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
# Function:
#	p6_obj_splice(obj, start, new)
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
# Function:
#	p6_obj_trim(obj)
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
# Function:
#	p6_obj_lc(obj)
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
# Function:
#	p6_obj_uc(obj)
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
# Function:
#	p6_obj__meta_init(obj, class)
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
# Function:
#	p6_obj__data_init(obj)
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
# Function:
#	p6_obj__dispatch(obj, method)
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

  local class=$(p6_obj_class "$obj")

  p6_obj__debug "__dispatch(): [obj=$obj] [method=$method] [class=$class] [$@]"
  p6_store_${class}_${method} "$obj" "$@"
}

######################################################################
#<
#
# Function:
#	str meta = p6_obj__meta__key()
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
# Function:
#	str data = p6_obj__data__key()
#
#  Returns:
#	str - data
#
#>
######################################################################
p6_obj__data__key() {

    p6_return_str "data"
}