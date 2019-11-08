# Object
#
# [object]
#   meta/
#     class
#     length
#     iterators/
#       default
#     _hist
#   data/
#     0/
#       data: string-data
#     0/
#       data: list-item-1-data
#     md5(key)/
#        key: hash-key-data
#        val: hash-val-data

p6_obj__debug() {
    local msg="$1"

    p6_debug "p6_obj: $msg"
}

###
### Pulic
###

##
## Constructors
##

p6_obj_create() {
    local class="$1"

    local obj=$(p6_store_create "objs/$class" "4")

    p6_obj__meta_init "$obj"
    p6_obj__data_init "$obj"
    p6_obj__class "$obj" "$class"

    p6_return_obj_ref "$obj"
}

p6_obj_copy() {
    local obj="$1"

    local class=$(p6_obj__class "$obj")

    local copy=$(p6_obj_create "$class")

    p6_store_copy "$obj" "$copy"

    p6_return_obj_ref "$copy"
}

p6_obj_destroy() {
    local obj="$1"

    p6_store_destroy "$obj"

    p6_return_void
}

##
## Equality
##

p6_obj_compare() {
    local a="$1"
    local b="$2"

    local rc=$(p6_obj__dispatch "$a" "compare" "$b")

    p6_return_size_t "$rc"
}

##
## Assignment
##

p6_obj_assign() {
    local obj="$1"

    local ref=$(p6_store_ref "$obj")

    p6_return_obj_ref "$ref"
}

##
## toString()
##

p6_obj_display() {
    local obj="$1"

    p6_obj__dispatch "$obj" "display"

    p6_return_void
}

##
## Iterators
##

p6_obj_iter_index() {
    local obj="$1"
    local var="${2:-default}"

    local index=$(p6_iter_index "$obj" "$var")

    p6_return_size_t "$index"
}

p6_obj_iter_more() {
    local obj="$1"
    local var="${2:-default}"
    local offset="${3:-0}"

    local i=$(p6_obj_iter_index "$obj" "$var" "$offset")
    local len=$(p6_obj_length "$obj")

    local bool=$(p6_math_le "$i" "$len")

    p6_obj__debug "iter_more(): [i=$i] [len=$len] -> [bool=$bool]"

    p6_return_bool "$bool"
}

p6_obj_iter_current() {
    local obj="$1"
    local var="${2:-default}"

    p6_obj__debug "iter_current(): [obj=$obj] [var=$var]"
    local i=$(p6_iter_index "$obj" "$var")

    local item=$(p6_obj_iter_i "$obj" "$var" "$i")

    p6_return_item_ref "$item"
}

p6_obj_iter_i() {
    local obj="$1"
    local var="${2:-default}"
    local i="$3"

    p6_obj__dispatch "$obj" "iter_i" "$var" "$i"
}

p6_obj_iter_ate() {
    local obj="$1"
    local var="${2:-default}"
    local move="${3:-1}"

    # XXX TBD
}

p6_obj_foreach() {
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
}

##
## READ Operations
##

p6_obj_length() {
    local obj="$1"

    local meta_key=$(p6_obj__meta__key)

    local length=$(p6_store_hash_get "$obj" "$meta_key" "length")

    p6_return_size_t "$length"
}

p6_obj_grep() {
    local obj="$1"
    local pattern="$2"

    p6_obj__dispatch "$obj" "grep" "$pattern"
}

##
## Write Operations (to myself)
##

p6_obj_reverse() {
    local obj="$1"

    p6_obj__dispatch "$obj" "reverse"
}

p6_obj_splice() {
    local obj="$1"
    local start="$2"
    local new="$3"

    p6_obj__dispatch "$obj" "splice" "$start" "$new"
}

p6_obj_trim() {
    local obj="$1"

    p6_obj__dispatch "$obj" "trim"
}

p6_obj_lc() {
    local obj="$1"

    p6_obj__dispatch "$obj" "lc"
}

p6_obj_uc() {
    local obj="$1"

    p6_obj__dispatch "$obj" "uc"
}

###
### Protected
###

p6_obj__dispatch() {
    local obj="$1"
    local method="$2"
    shift 2

    local class=$(p6_obj__class "$obj")

    p6_obj__debug "__dispatch(): [obj=$obj] [method=$method] [class=$class] [$@]"
    p6_obj_${class}_${method} "$obj" "$@"
}

###
### Private
###

p6_obj__meta_init() {
    local obj="$1"

    local meta_key=$(p6_obj__meta__key)

    p6_store_hash_create "$obj" "iterators"

    p6_store_hash_create "$obj" "$meta_key"
    local old_class=$(p6_store_hash_set "$obj" "$meta_key" "class" "obj")
    local old_length=$(p6_store_hash_set "$obj" "$meta_key" "length" "0")

    p6_return_void
}

p6_obj__data_init() {
    local obj="$1"

    local data_key=$(p6_obj__data__key)

    p6_store_hash_create "$obj" "$data_key"

    p6_return_void
}

p6_obj__class() {
    local obj="$1"
    local new="$2"

    local meta_key=$(p6_obj__meta__key)
    if ! p6_string_blank "$new"; then
	local old_class=$(p6_store_hash_set "$obj" "$meta_key" "class" "$new")
    fi

    p6_return_str "$old_class"
}

p6_obj__meta__key() {

    p6_return_str "meta"
}

p6_obj__data__key() {

    p6_return_str "data"
}
o
