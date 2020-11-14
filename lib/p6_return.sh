# This works like MixIns in Ruby

######################################################################
#<
#
# Function: path obj = p6_return_obj()
#
#  Returns:
#	path - obj
#
#>
######################################################################
p6_return_obj() {
    local obj="$1"

    p6_return_path "$obj"
}

######################################################################
#<
#
# Function: path item = p6_return_item(item)
#
#  Args:
#	item -
#
#  Returns:
#	path - item
#
#>
######################################################################
p6_return_item() {
    local item="$1"

    p6_return_path "$item"
}