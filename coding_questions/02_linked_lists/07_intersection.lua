--[[
    Given two (singly) linked lists, determine if the two lists intersect. Return the intersecting
    node. Note that the intersection is defined based on reference, not value. That is, if the kth
    node of the first linked list is the exact same node (by reference) as the jth node of the second
    linked list, then they are intersecting.
]]

local LinkedList = require 'linked_list'
local math = require 'math'
local dbg = require 'debugger'

-- solution 1: store references into hash
function intersection(list1, list2)
    -- first, compare the tails. if they are not the same by reference, we don't have an intersectoin
    if list1.tail ~= list2.tail
    then
        return false
    end

    local fast, slow = determine_fast_slow_nodes(list1, list2)

    for i = 1, math.abs(list1.count - list2.count) do
        fast = fast.next
    end

    while slow and fast do
        if slow == fast
        then
            return slow
        end

        slow = slow.next
        fast = fast.next
    end

    return false
end

function determine_fast_slow_nodes(list1, list2)
    if list1.count > list2.count
    then
        return list1.head, list2.head
    else
        return list2.head, list1.head
    end
end

function display(list1, list2, func)
    local result = func(list1, list2)

    io.write('list1 intersects list2 at: ' .. tostring(result) .. ' | ')
    
    if result then print(result.value) end
end

local list1 = LinkedList:new({1, 2, 3, 4, 5, 6, 7})
local node = list1:find(4)
local list2 = LinkedList:new({9, 8})
list2:add_by_node(node)

display(list1, list2, intersection)

local list1 = LinkedList:new({1, 2, 3, 4, 5, 6, 7})
local node = list1:find(4)
local list2 = LinkedList:new({9, 8, 7, 6, 5, 4, 3})

print()
display(list1, list2, intersection)
print()
