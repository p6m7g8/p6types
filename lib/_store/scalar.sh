######################################################################
#<
#
# Function: p6_store_scalar__debug(msg)
#
#  Args:
#	msg - 
#
#>
######################################################################
p6_store_scalar__debug() {
    local msg="$1"

    p6_debug "p6_store_scalar: $msg"

    p6_return_void
}

######################################################################
#<
#
# Function: p6_store_scalar_create(store, name)
#
#  Args:
#	store - the store
#	name - the name of the scalar
#
#>
######################################################################
p6_store_scalar_create() {
    local store="$1" # the store
    local name="$2"  # the name of the scalar

    p6_store__init_structure "$store" "$name"

    p6_return_void
}

######################################################################
#<
#
# Function: str val = p6_store_scalar_get(store, name)
#
#  Args:
#	store - the store
#	name - the name of the scalar
#
#  Returns:
#	str - val: value of the scalar
#
#>
######################################################################
p6_store_scalar_get() {
    local store="$1" # the store
    local name="$2"  # the name of the scalar

    local disk_dir=$(p6_store__disk "$store" "$name")
    local val=$(p6_file_display "$disk_dir/data")

    p6_return_str "$val" # value of the scalar
}

######################################################################
#<
#
# Function: str val = p6_store_scalar_set(store, name, new)
#
#  Args:
#	store - the store
#	name - the name of the scalar
#	new - set scalar value to this
#
#  Returns:
#	str - val: the value
#
#>
######################################################################
p6_store_scalar_set() {
    local store="$1" # the store
    local name="$2"  # the name of the scalar
    local new="$3"   # set scalar value to this

    local disk_dir=$(p6_store__disk "$store" "$name")
    local file="$disk_dir/data"

    local val=$(p6_file_display "$file")

    p6_file_write "$file" "$new"

    p6_return_str "$val" # the value
}