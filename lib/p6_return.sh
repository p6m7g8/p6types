# This works like MixIns in Ruby

######################################################################
#<
#
# Function: p6_return_obj()
#
#>
######################################################################
p6_return_obj() {
    local obj="$1"

    p6_return__ "$obj"
}

######################################################################
#<
#
# Function: p6_return_item(item)
#
#  Args:
#	item - 
#
#>
######################################################################
p6_return_item() {
    local item="$1"

    p6_return__ "$item"
}