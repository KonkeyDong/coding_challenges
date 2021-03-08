--[[
    Partition: write code to partition a linked list around a value x, 
    such that all nodes less than x come before all nodes greater than or equal to x.
    if X is contained within the list, the values of x only need to be after the elements
    less than x (see below). The partition element X can appear anywhere in the "right partition";
    it does not need to appear between the left and right partitions.

    Example:

    input:  3->5->8->5->10->2->1; partition = 5
    output: 3->1->2->10->5->5->8
]]

local path = require 'pl.path'.abspath('../data_structures')
package.path = package.path .. ';' .. path .. '/linked_list.lua'
local LinkedList = require 'data_structures.linked_list'

-- Solution 1: use two separate linked lists to store the lower and upper;
--             Link the lists together and return the lower linked list.
function partition(list, x)
    local node = list.head
    local lower = LinkedList:new()
    local higher = LinkedList:new()

    while node do
        if node.value < x
        then
            lower:add(node.value)
        else
            higher:add(node.value)
        end

        node = node.next
    end

    lower.tail.next = higher.head
    higher.head.prev = lower.tail
    return lower
end

local list = LinkedList:new({3, 5, 8, 5, 10, 2, 1})
print('solution 1: before')
list:print()

local new_list = partition(list, 5)

print('\nsolution 1: after')
new_list:print()
