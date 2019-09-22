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
#

###
### Pulic
###

##
## Constructors
##

# obj p6_obj_create(string)
#
######################################################################
#<
#
# Function:
#      = p6_obj_create()
#
#
#
#>
######################################################################
p6_obj_create() {
    local class="$1"

    p6_obj__create "$class"
}

# obj p6_obj_copy(obj)
#
######################################################################
#<
#
# Function:
#      = p6_obj_copy(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj_copy() {
    local obj="$1"

    p6_obj__copy "$obj"
}

# void p6_obj_destroy(obj)
#
######################################################################
#<
#
# Function:
#      = p6_obj_destroy(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj_destroy() {
    local obj="$1"

    p6_obj__destroy "$obj"
}

##
## Equality
##

# size_t p6_obj_compare(obj, obj)
#
######################################################################
#<
#
# Function:
#      = p6_obj_compare()
#
#
#
#>
######################################################################
p6_obj_compare() {
    local a="$1"
    local b="$2"

    p6_obj__dispatch "$a" "compare" "$b"
}

##
## Assignment
##

# obj p6_obj_assign(obj)
#
######################################################################
#<
#
# Function:
#      = p6_obj_assign(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj_assign() {
    local obj="$1"

    p6_obj__assign "$obj"
}

##
## toString()
##

# void p6_obj_display(obj)
#
######################################################################
#<
#
# Function:
#      = p6_obj_display(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj_display() {
    local obj="$1"

    p6_obj__dispatch "display"
}

##
## Iterators
##

# bool p6_obj_iter_index(obj, var)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_iter_index(obj, var)
#
# Arg(s):
#    obj - 
#    var - 
#
#
#>
######################################################################
p6_obj_iter_index() {
    local obj="$1"
    local var="${2:-default}"

    p6_obj__iter_index "$obj" "$var"
}

# bool p6_obj_iter_more(obj) {
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_iter_more(obj, var, offset)
#
# Arg(s):
#    obj - 
#    var - 
#    offset - 
#
#
#>
######################################################################
p6_obj_iter_more() {
    local obj="$1"
    local var="${2:-default}"
    local offset="${3:-0}"

    p6_obj__iter_more "$obj" "$var" "$offset"
}

# ITEM p6_obj_iter_current(obj)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_iter_current(obj, var)
#
# Arg(s):
#    obj - 
#    var - 
#
#
#>
######################################################################
p6_obj_iter_current() {
    local obj="$1"
    local var="${2:-default}"

    local i=$(p6_iter_index "$obj" "$var")

    p6_obj__iter_i "$obj" "$var" "$i"
}

# ITEM p6_obj_iter_i(obj, int)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_iter_i(obj, var)
#
# Arg(s):
#    obj - 
#    var - 
#
#
#>
######################################################################
p6_obj_iter_i() {
    local obj="$1"
    local var="${2:-default}"
    local i="$3"

    p6_obj__iter_i "$obj" "$var" "$i"
}

# bool p6_obj_iter_ate(obj, var, offset, move):
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_iter_ate(obj, var, move)
#
# Arg(s):
#    obj - 
#    var - 
#    move - 
#
#
#>
######################################################################
p6_obj_iter_ate() {
    local obj="$1"
    local var="${2:-default}"
    local move="${3:-1}"

    p6_obj__iter_ate "$obj" "$var" "$move"
}

# void p6_obj_foreach(obj, callback)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_foreach(obj, callback)
#
# Arg(s):
#    obj - 
#    callback - 
#
#
#>
######################################################################
p6_obj_foreach() {
    local obj="$1"
    local callback="$2"

    while p6_obj_iter_more "$obj"; do
	local item=$(p6_obj_iter_current "$obj")

	p6_yield "$callback" "$obj" "$item"

	p6_obj_iter_ate "$obj"
    done
}

##
## READ Operations
##

# size_t p6_obj_length(obj)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_length(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj_length() {
    local obj="$1"

    p6_obj__length "$obj"
}

# size_t p6_obj_grep(obj, pattern)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_grep(obj, pattern)
#
# Arg(s):
#    obj - 
#    pattern - 
#
#
#>
######################################################################
p6_obj_grep() {
    local obj="$1"
    local pattern="$2"

    p6_obj__dispatch "$obj" "grep" "$pattern"
}

##
## Write Operations (to myself)
##

# size_t p6_obj_reverse(obj, size_t, obj)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_reverse(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj_reverse() {
    local obj="$1"

    p6_obj__dispatch "$obj" "reverse"
}

# size_t p6_obj_splice(obj, size_t, obj)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_splice(obj, start, new)
#
# Arg(s):
#    obj - 
#    start - 
#    new - 
#
#
#>
######################################################################
p6_obj_splice() {
    local obj="$1"
    local start="$2"
    local new="$3"

    p6_obj__dispatch "$obj" "splice" "$start" "$new"
}

# void p6_obj_trim(obj)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_trim(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj_trim() {
    local obj="$1"

    p6_obj__dispatch "$obj" "trim"
}

# void p6_obj_lc(obj)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_lc(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj_lc() {
    local obj="$1"

    p6_obj__dispatch "$obj" "lc"
}

# void p6_obj_uc(obj)
#   CLASS: str, list, hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_uc(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj_uc() {
    local obj="$1"

    p6_obj__dispatch "$obj" "uc"
}

###
### Protected
###

###
### Private
###

##
## Iterators
##
######################################################################
#<
#
# Function:
#      = p6_obj__iter_more(obj, var, offset)
#
# Arg(s):
#    obj - 
#    var - 
#    offset - 
#
#
#>
######################################################################
p6_obj__iter_more() {
    local obj="$1"
    local var="$2"
    local offset="$3"

    local i=$(p6_obj__iter_index "$obj" "$var" "$offset")
    local len=$(p6_obj__length "$obj")

    p6_math_le "$i" "$len"
}

######################################################################
#<
#
# Function:
#      = p6_obj__iter_i(obj, var)
#
# Arg(s):
#    obj - 
#    var - 
#
#
#>
######################################################################
p6_obj__iter_i() {
    local obj="$1"
    local var="$2"
    local i="$3"

    p6_obj__dispatch "$obj" "iter_i" "$var" "$i"
}

######################################################################
#<
#
# Function:
#      = p6_obj__iter_ate(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj__iter_ate() {
    local obj="$1"


}

##
## Util
##
######################################################################
#<
#
# Function:
#      = p6_obj__dispatch(obj, method)
#
# Arg(s):
#    obj - 
#    method - 
#
#
#>
######################################################################
p6_obj__dispatch() {
    local obj="$1"
    local method="$2"
    shift 2

    local class=$(p6_obj__class "$obj")

    p6_obj_${class}_${method} "$obj" "$@"
}

##
## Constructors
##
######################################################################
#<
#
# Function:
#     $obj = p6_obj__create(class)
#
# Arg(s):
#    class - 
#
# Return(s):
#    $obj - 
#
#>
######################################################################
p6_obj__create() {
    local class="$1"

    local obj=$(p6_obj__init "$class")

    p6_obj__meta_init "$obj"
    p6_obj__data_init "$obj"

    p6_obj__class "$obj" "$class"

    p6_return "$obj"
}

######################################################################
#<
#
# Function:
#      = p6_obj__copy(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj__copy() {
    local obj="$1"

    local class=$(p6_obj__class "$obj")
    local copy=$(p6_obj__create "$class")
    p6_obj__clone "$obj" "$copy"
}

###
### XXX
###
######################################################################
#<
#
# Function:
#      = p6_obj__iter_index(obj, var)
#
# Arg(s):
#    obj - 
#    var - 
#
#
#>
######################################################################
p6_obj__iter_index() {
    local obj="$1"
    local var="$2"

    p6_iter_index "$obj" "$var"
}

######################################################################
#<
#
# Function:
#      = p6_obj__destroy(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj__destroy() {
    local obj="$1"

    p6_store_destroy "$obj"
}

######################################################################
#<
#
# Function:
#      = p6_obj__assign(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj__assign() {
    local obj="$1"

    p6_store_ref "$obj"
}

######################################################################
#<
#
# Function:
#      = p6_obj__clone(obj, dst)
#
# Arg(s):
#    obj - 
#    dst - 
#
#
#>
######################################################################
p6_obj__clone() {
    local obj="$1"
    local dst="$2"

    p6_store_copy "$obj" "$dst"
}

######################################################################
#<
#
# Function:
#      = p6_obj__class(obj, new)
#
# Arg(s):
#    obj - 
#    new - 
#
#
#>
######################################################################
p6_obj__class() {
    local obj="$1"
    local new="$2"

    local meta_key=$(p6_obj__meta__key)
    if ! p6_string_blank "$new"; then
	p6_store_hash_set "$obj" "$meta_key" "class" "$new"
    fi
}

######################################################################
#<
#
# Function:
#      = p6_obj__length(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj__length() {
    local obj="$1"

    local meta_key=$(p6_obj__meta__key)

    p6_store_hash_get "$obj" "$meta_key" "length"
}

######################################################################
#<
#
# Function:
#      = p6_obj__init(class)
#
# Arg(s):
#    class - 
#
#
#>
######################################################################
p6_obj__init() {
    local class="$1"

    p6_store_create "objs/$class" "4"
}

######################################################################
#<
#
# Function:
#      = p6_obj__meta_init(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj__meta_init() {
    local obj="$1"

    local meta_key=$(p6_obj__meta__key)

    p6_store_hash_create "$obj" "iterators"

    p6_store_hash_create "$obj" "$meta_key"
    p6_store_hash_set "$obj" "$meta_key" "class" "obj"
    p6_store_hash_set "$obj" "$meta_key" "length" "0"
}

######################################################################
#<
#
# Function:
#      = p6_obj__data_init(obj)
#
# Arg(s):
#    obj - 
#
#
#>
######################################################################
p6_obj__data_init() {
    local obj="$1"

    local data_key=$(p6_obj__data__key)

    p6_store_hash_create "$obj" "$data_key"
}

######################################################################
#<
#
# Function:
#     meta = p6_obj__meta__key()
#
#
# Return(s):
#    meta - 
#
#>
######################################################################
p6_obj__meta__key() {

    p6_return "meta"
}

######################################################################
#<
#
# Function:
#     data = p6_obj__data__key()
#
#
# Return(s):
#    data - 
#
#>
######################################################################
p6_obj__data__key() {

    p6_return "data"
}