# Hash < Object
#
# [hash]
#   <rand(12)>
#	  key
#	  data

###
### Public
###

# hash p6_obj_hash_create()
#    CLASS: hash
#
######################################################################
#<
#
# Function:
#     $hash = p6_obj_hash_create()
#
#
# Return(s):
#    $hash - 
#
#>
######################################################################
p6_obj_hash_create() {

    local hash=$(p6_obj_create "hash")

    p6_obj_hash__items_init "$hash"

    p6_return "$hash"
}

# size_t p6_obj_hash_compare(hash, hash)
#    CLASS: hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_hash_compare()
#
#
#
#>
######################################################################
p6_obj_hash_compare() {
    local a="$1"
    local b="$2"

    p6_obj_hash__compare "$a" "$b"
}

# void p6_obj_hash_display(hash)
#    CLASS: hash
#
######################################################################
#<
#
# Function:
#      = p6_obj_hash_display(hash)
#
# Arg(s):
#    hash - 
#
#
#>
######################################################################
p6_obj_hash_display() {
    local hash="$1"

    p6_obj_foreach "$list" "" "p6_obj_hash__item_display"
}

# list p6_obj_hash_keys(hash)
#   CLASS: hash
#
######################################################################
#<
#
# Function:
#     $list = p6_obj_hash_keys(hash)
#
# Arg(s):
#    hash - 
#
# Return(s):
#    $list - 
#
#>
######################################################################
p6_obj_hash_keys() {
    local hash="$1"

    local list=$(p6_obj_list_create)

    p6_obj_foreach "$hash" "" "p6_obj_hash__key_to_list" "$list"

    p6_return "$list"
}

# ITEM p6_obj_hash_get(hash, key)
#   CLASS: hash
#
######################################################################
#<
#
# Function:
#     $item = p6_obj_hash_get(hash, key)
#
# Arg(s):
#    hash - 
#    key - 
#
# Return(s):
#    $item - 
#
#>
######################################################################
p6_obj_hash_get() {
    local hash="$1"
    local key="$2"

    local data_key=$(p6_obj__data__key)
    local item=$(p6_store_hash_get "$obj" "$data_key" "$key")

    p6_return "$item"
}

# list p6_obj_hash_values(hash)
#   CLASS: hash
#
######################################################################
#<
#
# Function:
#     $list = p6_obj_hash_values(hash)
#
# Arg(s):
#    hash - 
#
# Return(s):
#    $list - 
#
#>
######################################################################
p6_obj_hash_values() {
    local hash="$1"

    local list=$(p6_obj_list_create)

    p6_obj_foreach "$hash" "" "p6_obj_hash__values_to_list" "$list"

    p6_return "$list"
}

###
### Private
###

###
### XXX
###
######################################################################
#<
#
# Function:
#      = p6_obj_hash__items_init(hash, list)
#
# Arg(s):
#    hash - 
#    list - 
#
#
#>
######################################################################
p6_obj_hash__items_init() {
    local hash="$1"

    p6_store_bucket_hash_create "$hash" "data" "items"
}