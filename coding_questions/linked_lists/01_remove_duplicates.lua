-- Remove duplicates: write code to remove all duplicates from a linked list.
-- {1, 2, 2, 3, 3, 3} => {1, 2, 3}

-- FOLLOW UP: how would you solve this provlem if a temporary buffer is not allowed?

local tablex = require 'pl.tablex'

-- SOLUTION 1: use a Set to store data
local path = require 'pl.path'.abspath('../data_structures')
package.path = package.path .. ';' .. path .. '/linked_list.lua'
local LinkedList = require 'data_structures.linked_list'

local list = LinkedList:new({1, 2, 2, 3, 3, 3})
local set = {}
print('Original list:')
list:print()

local node = list.head
while node do
    set[node.value] = true
    node = node.next
end

print('\n----------\nRemoved Duplicates:')
for key, value in pairs(set) do
    print(key) -- or loop over set and add to linked list.
end


-- Solution 2: no extra storage (however, runs O(n^2))
local list = LinkedList:new({1, 2, 2, 3, 3, 3})
local current = list.head
print('\n----------\nSOLUTION 2\nOriginal list:')
list:print()

while current do
    local runner = current
    while runner.next do -- look ahead to prevent referncing a nil node
        if runner.next.value == current.value
        then
            runner.next = runner.next.next
        else
            runner = runner.next
        end
    end

    current = current.next
end

print('\n----------\nRemoved Duplicates:')
list:print()
