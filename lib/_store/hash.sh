######################################################################
#<
#
# Function: p6_store_hash__debug(msg)
#
#  Args:
#	msg - 
#
#>
######################################################################
p6_store_hash__debug() {
    local msg="$1"

    p6_debug "p6_store_hash: $msg"

    p6_return_void
}

######################################################################
#<
#
# Function: p6_store_hash_create(store, name)
#
#  Args:
#	store - the store
#	name - the name of the hash
#
#>
######################################################################
p6_store_hash_create() {
    local store="$1" # the store
    local name="$2"  # the name of the hash

    p6_store__init_structure "$store" "$name"

    p6_return_void
}
######################################################################
#<
#
# Function: str val = p6_store_hash_get(store, name, key)
#
#  Args:
#	store - the store
#	name - the name of the hash
#	key - the key to get the value of
#
#  Returns:
#	str - val: the value of the key
#
#>
######################################################################
p6_store_hash_get() {
    local store="$1" # the store
    local name="$2"  # the name of the hash
    local key="$3"   # the key to get the value of

    if ! p6_string_blank "$key"; then
	local disk_dir=$(p6_store__disk "$store" "$name")

	local key_hash=$(p6_token_hash "$key")
	local pair_dir="$disk_dir/$key_hash"

	local val=$(p6_file_display "$pair_dir/value")
	p6_return_str "$val" # the value of the key
    else
	p6_return_void
    fi
}

######################################################################
#<
#
# Function: str old = p6_store_hash_set(store, name, key, val)
#
#  Args:
#	store - the store
#	name - the name of the hash
#	key - the key who's value to set
#	val - value to set
#
#  Returns:
#	str - old: the previous value of key
#
#>
######################################################################
p6_store_hash_set() {
    local store="$1" # the store
    local name="$2"  # the name of the hash
    local key="$3"   # the key who's value to set
    local val="$4"   # value to set

    if ! p6_string_blank "$key"; then
	local key_hash=$(p6_token_hash "$key")
	local disk_dir=$(p6_store__disk "$store" "$name")
	local pair_dir="$disk_dir/$key_hash"

	p6_dir_mk "$pair_dir"
	p6_file_create "$pair_dir/key"
	p6_file_write "$pair_dir/key" "$key"

	local old=$(p6_file_display "$pair_dir/value")
	p6_file_create "$pair_dir/value"
	p6_file_write "$pair_dir/value" "$val"
	p6_return_str "$old" # the previous value of key
    else
	p6_return_void
    fi
}

######################################################################
#<
#
# Function: str old_val = p6_store_hash_delete(store, name, key)
#
#  Args:
#	store - the store
#	name - the name of the hash
#	key - the key to delete
#
#  Returns:
#	str - old_val: previou key value
#
#>
######################################################################
p6_store_hash_delete() {
    local store="$1" # the store
    local name="$2"  # the name of the hash
    local key="$3"   # the key to delete

    local key_hash=$(p6_token_hash "$key")

    local disk_dir=$(p6_store__disk "$store" "$name")
    local pair_dir="$disk_dir/$key_hash"

    local old_val=$(p6_file_display "$pair_dir/value")

    p6_dir_rmrf "$pair_dir"

    p6_return_str "$old_val" # previou key value
}