#
# Store
# [store]
# name/ (string)
#   string: string-data
# name/ (hash)
#   md5(key)/
#     key: hash-key-data
#     val: hash-val-data
# name/ (list)
#   i: i value
#   [i]:/
#     data: item data
#

######################################################################
#<
#
# Function:
#	p6_store__debug()
#
#>
######################################################################
p6_store__debug() {
    local msg="$1"

    p6_debug "p6_store: $msg"

    p6_return_void
}

######################################################################
#<
#
# Function:
#	p6_store_create(name, max_objs)
#
#  Args:
#	name - name of store
#	max_objs - max objects
#
#>
#/ Synopsis:
#/   Creates a temporal object store
#/
######################################################################
p6_store_create() {
    local name="$1"     # name of store
    local max_objs="$2" # max objects

    local store=$(p6_transient_create "$name" "$max_objs")

    p6_return_obj "$store" # reference to object store
}

######################################################################
#<
#
# Function:
#	p6_store_destroy(store)
#
#  Args:
#	store - ref to store to delete
#
#>
######################################################################
p6_store_destroy() {
    local store="$1" # ref to store to delete

    p6_transient_delete "$store"

    p6_return_void
}

######################################################################
#<
#
# Function:
#	p6_store_ref(store)
#
#  Args:
#	store - store to find ref of
#
#>
######################################################################
p6_store_ref() {
    local store="$1" # store to find ref of

    local ref=$(p6_store__ref "$store")

    p6_return_obj "$ref" # ref to store
}

######################################################################
#<
#
# Function:
#	p6_store_copy(store)
#
#  Args:
#	store - store to copy
#
#>
######################################################################
p6_store_copy() {
    local store="$1" # store to copy

    local copy=$(p6_store__copy "$store")

    p6_return_obj "$copy" # copied store
}

######################################################################
#<
#
# Function:
#	p6_store__init_structure(store, name)
#
#  Args:
#	store - the store
#	name - the 'bucket' name
#
#>
######################################################################
p6_store__init_structure() {
    local store="$1" # the store
    local name="$2"  # the 'bucket' name

    local disk_dir=$(p6_store__disk "$store" "$name")
    p6_dir_mk "$disk_dir"

    p6_return_void
}

######################################################################
#<
#
# Function:
#	path dir = p6_store__disk(store, name)
#
#  Args:
#	store - the store
#	name - the name of the list
#
#  Returns:
#	path - dir: the on disk location as a path
#
#>
######################################################################
p6_store__disk() {
    local store="$1" # the store
    local name="$2"  # the name of the list

    local dir="$store/$name"

    p6_return_path "$dir" # the on disk location as a path
}