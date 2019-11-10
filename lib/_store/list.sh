######################################################################
#<
#
# Function: p6_store_list__debug(msg)
#
#  Args:
#	msg - 
#
#>
######################################################################
p6_store_list__debug() {
    local msg="$1"

    p6_debug "p6_store_list: $msg"

    p6_return_void
}

######################################################################
#<
#
# Function: p6_store_list_create(store, name)
#
#  Args:
#	store - the store
#	name - the name of the list
#
#>
######################################################################
p6_store_list_create() {
    local store="$1" # the store
    local name="$2"  # the name of the list

    p6_store__init_structure "$store" "$name"

    p6_return_void
}

######################################################################
#<
#
# Function: p6_store_list_get(store, name, i)
#
#  Args:
#	store - the store
#	name - the name of the list
#	i - index of list item to return
#
#>
######################################################################
p6_store_list_get() {
    local store="$1" # the store
    local name="$2"  # the name of the list
    local i="$3"     # index of list item to return

    if ! p6_string_blank "$i"; then
	local disk_dir=$(p6_store__disk "$store" "$name")
	local item_dir="$disk_dir/$i"

	local item=$(p6_file_display "$item_dir/data")

	p6_return_item "$item" # the item
    fi
}

######################################################################
#<
#
# Function: str i_val = p6_store_list_add(store, name, new)
#
#  Args:
#	store - the store
#	name - the name of the list
#	new - new item to add
#
#  Returns:
#	str - i_val: value of added item
#
#>
######################################################################
p6_store_list_add() {
    local store="$1" # the store
    local name="$2"  # the name of the list
    local new="$3"   # new item to add

    local disk_dir=$(p6_store__disk "$store" "$name")

    # current i
    local i_val=$(p6_store_list__i "$disk_dir")

    # make item dir
    local item_dir="$disk_dir/$i_val"
    p6_dir_mk "$item_dir"

    # save data
    p6_file_create "$item_dir/data"
    if ! p6_string_blank "$new"; then
	p6_file_write "$item_dir/data" "$new"
    fi

    # increment
    local next=$(p6_math_inc "$i_val")
    p6_store_list__i "$disk_dir" "$next"

    p6_return_str "$i_val" # value of added item
}

######################################################################
#<
#
# Function: size_t j = p6_store_list_item_delete(store, name, old)
#
#  Args:
#	store - the store
#	name - the name of the list
#	old - value to delete [1st one]
#
#  Returns:
#	size_t - j: index of deleted item
#
#>
######################################################################
p6_store_list_item_delete() {
    local store="$1" # the store
    local name="$2"  # the name of the list
    local old="$3"   # value to delete [1st one]

    local disk_dir=$(p6_store__disk "$store" "$name")

    # current i
    local i_val=$(p6_store_list__i "$disk_dir")

    local j=0
    while [ $j -lt $i_val ]; do
	local item_dir="$disk_dir/$j"

	local data=$(p6_file_display "$item_dir/data")
	if [ x"$old" = x"$data" ]; then

	    local junk=$(p6_store_list_delete "$store" "$name" "$j")
	    p6_return_size_t "$j" # index of deleted item
	    break
	fi
	j=$(p6_math_inc "$j")
    done

    p6_return_void
}

######################################################################
#<
#
# Function: p6_store_list_delete(store, name, i)
#
#  Args:
#	store - the store
#	name - the name of the list
#	i - index of item to delete
#
#>
######################################################################
p6_store_list_delete() {
    local store="$1" # the store
    local name="$2"  # the name of the list
    local i="$3"     # index of item to delete

    if ! p6_string_blank "$i"; then
	local disk_dir=$(p6_store__disk "$store" "$name")
	local item_dir="$disk_dir/$i"
	local old=$(p6_file_display "$item_dir/data")
	p6_dir_rmrf "$item_dir"

	p6_return_item "$old" # old item
    else
	p6_return_void
    fi
}

######################################################################
#<
#
# Function: size_t next = p6_store_list__i(disk_dir, [next=])
#
#  Args:
#	disk_dir - path to on disk location
#	OPTIONAL next - optional next value []
#
#  Returns:
#	size_t - next: new i value
#	size_t - i_val: i's value
#
#>
######################################################################
p6_store_list__i() {
    local disk_dir="$1" # path to on disk location
    local next="${2:-}" # optional next value

    # current i
    local i_file="$disk_dir/i"
    if [ -n "$next" ]; then
	p6_file_write "$i_file" "$next"
	p6_return_size_t "$next" # new i value
    else
	local i_val=-1
	if ! p6_file_exists "$i_file"; then
	    p6_file_create "$i_file"
	    i_val=0
	else
	    i_val=$(p6_file_display "$i_file")
	fi

	p6_return_size_t "$i_val" # i's value
    fi
}