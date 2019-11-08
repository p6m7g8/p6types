p6_store_iter__debug() {
    local msg="$1"

    p6_debug "p6_store_iter: $msg"

    p6_return_void
}

p6_iter_create() {
    local store="$1" # the store
    local name="$2"  # the name of the iterator

    p6_store__init_structure "$store" "$name"

    local disk_dir=$(p6_store__disk "$store" "$name")
    local file="$disk_dir/data"

    p6_file_write "$file" "0"

    p6_return_void
}

p6_iter_destroy() {
    local obj="$1"

    p6_store_destroy "$obj"

    p6_return_void
}

p6_iter_current() {
    local store="$1" # the store
    local name="$2"  # the name of the iterator

    local disk_dir=$(p6_store__disk "$store" "$name")
    local val=$(p6_file_display "$disk_dir/data")

    p6_return_size_t "$val" # value of the iterator
}

p6_iter_move() {
    local store="$1" # the store
    local name="$2"  # the name of the scalar
    local delta="$3" # iterate by delta

    local disk_dir=$(p6_store__disk "$store" "$name")
    local file="$disk_dir/data"

    local val=$(p6_file_display "$file")

    local new=$(($val + $delta))

    p6_file_write "$file" "$new"

    p6_return_void
}
