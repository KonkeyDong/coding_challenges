-- Implement a function that determines if a linked-list is a palindrome.

local LinkedList = LinkedList or require 'linked_list'
local tablex = require 'pl.tablex'
local stringx = require 'pl.stringx'
local dbg = require "debugger"

-- SOLUTION 1: hash map (kind of works, but also works with permutations as well)
function palindrome(list)
    local set = {}
    local node = list.head

    while node do
        if set[node.value]
        then
            set[node.value] = nil
        else
            set[node.value] = true
        end

        node = node.next
    end

    if tablex.size(set) <= 1 then return 'true' else return 'false' end
end

function display(list, func)
    print(stringx.join(', ', list:values()) .. ': ' .. func(list))
end

-- display(LinkedList:new({1, 2, 3, 2, 1}), palindrome)
-- display(LinkedList:new({1, 2, 2, 1}), palindrome)
-- display(LinkedList:new({1, 2, 3, 1}), palindrome)
-- display(LinkedList:new({1, 1, 2, 2, 3}), palindrome) -- should be false, but it's true!
-- display(LinkedList:new({}), palindrome)

-- SOLUTION 2: iterative approach using a stack
function palindrome2(list)
    local stack = {}
    local slow = list.head
    local fast = list.head

    while fast and fast.next do
        table.insert(stack, slow.value)

        slow = slow.next
        fast = fast.next.next
    end

    -- ignore middle character if odd-sized list
    if fast ~= nil
    then
        slow = slow.next
    end

    while slow do
        if table.remove(stack) ~= slow.value
        then
            return 'false'
        end

        slow = slow.next
    end

    return 'true'
end

display(LinkedList:new({1, 2, 3, 2, 1}), palindrome2)
display(LinkedList:new({1, 2, 2, 1}), palindrome2)
display(LinkedList:new({1, 2, 3, 1}), palindrome2)
display(LinkedList:new({1, 1, 2, 2, 3}), palindrome2) -- should be false, but it's true!
display(LinkedList:new({}), palindrome2)

-- SOLUTION 3: recursive approach
function palindrome3(list)

end
