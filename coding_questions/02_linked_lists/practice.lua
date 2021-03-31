-- Practice to see if i understood the questions and can solve them without (much) help

--[[
    remove duplicates: write code to remove all duplicates from a linked list.
-- {1, 2, 2, 3, 3, 3} => {1, 2, 3}

-- FOLLOW UP: how would you solve this provlem if a temporary buffer is not allowed?
]]

local LinkedList = LinkedList or require 'linked_list'
local Stack = Stack or require 'stack'
local dbg = require 'debugger'

-- solution 1: temp storage O(n)
function remove_duplicates(list)
    local new_list = LinkedList:new()
    local map = {}
    local pointer = list.head

    while pointer do
        local value = pointer.value
        if not map[value]
        then
            map[value] = true
            new_list:add(value)
        end

        pointer = pointer.next
    end
    
    print('new linked list: ')
    new_list:print()
    print()
end

local list = LinkedList:new({1, 2, 2, 3, 3, 3})
remove_duplicates(list)

-- solution 2: no temp buffer (slower: O(n^2))
function remove_duplicates_no_temp_buffer(list)
    local current = list.head

    while current do
        local runner = current
        while runner.next do
            if runner.next.value == current.value
            then
                runner.next = runner.next.next
            else
                runner = runner.next
            end
        end

        current = current.next
    end

    list:print()
    print()
end
remove_duplicates_no_temp_buffer(list)

-- Return the kth node from the end: implement an algorithm to return the kth node from the end
-- solution: use slow/fast pointers
function remove_kth_element(list, k)
    -- iterate pointer by k units
    local pointer = list.head
    for i = 0, k do
        pointer = pointer.next
    end

    -- next, use slow/fast pointers
    local slow = pointer
    local fast = pointer
    while fast and fast.pointer do
        slow = slow.next
        fast = fast.next.next
    end

    print('The kth value is: ' .. slow.value)
    print()
end

remove_kth_element(LinkedList:new({1, 2, 3, 4, 5}), 2) -- 4

-- Delete Middle Node: Implement an algorithm to delete a node in the middle
-- (i.e., any node but the first and last nodes, not necessarily the middle)
-- of a singly-linked list, given only access to that node.

-- Example:
-- input: node C from the linked list a->b->c->d->e->f
-- result: nothing is returned, but the new list is: a->b->d->e->f

function delete_middle_node(node)
    -- edge case: node can't be from the end
    if not node or not node.next
    then
        return false -- fail 
    end

    local next_node = node.next
    node.value = next_node.value
    node.next = node.next.next

    return true
end

local list = LinkedList:new({'A', 'B', 'C', 'D', 'E'})
local node = list:find('C')
delete_middle_node(node)
list:print()

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

function partition(list, x)
    local lower = LinkedList:new()
    local upper = LinkedList:new()
    local pointer = list.head

    while pointer do
        if pointer.value < x
        then
            lower:add(pointer.value)
        else
            upper:add(pointer.value)
        end

        pointer = pointer.next
    end

    local new_list = lower + upper
    new_list:print()
end

local list = LinkedList:new({3, 5, 8, 5, 10, 2, 1})
partition(list, 5)


--[[
    SUM LISTS: You have two numbers represented by a linked list, where each node contains a single digit.
    The digits are sotred in reverse order, such that the 1's digit is at the head of the list.
    
    Write a function that adds the two numbers and returns the sum as a linked list.

    Example:
    INPUT: (7->1->6) + (5 -> 9 -> 2). That is, 617 + 295
    OUTPUT: 2->1->9. That is, 912

]]

function sum_list(list1, list2)
    print('sum_list')
    local sum = 0
    local multiplier = 1
    local carry = 0

    local node1 = list1.head
    local node2 = list2.head

    local adder = function(sub_total)
        if sub_total >= 10
        then
            carry = 1
            sub_total = sub_total % 10
        else
            carry = 0
        end

        sum = sum + sub_total * multiplier
        multiplier = multiplier * 10
    end

    while node1 or node2 do
        adder(node1.value + node2.value + carry)

        node1 = node1.next
        node2 = node2.next
    end

    -- get the node that still has data to traverse
    local runner = node1 and node1 or node2
    while runner do
        adder(runner.value + carry)

        runner = runner.next
    end

    print('Sum: ', sum)
end

local list1 = LinkedList:new({7, 1, 6})
local list2 = LinkedList:new({5, 9, 2})
sum_list(list1, list2)

-- follow up: forward ordering (don't reverse traverse the double-linked list!)
-- INPUT: (6 -> 1 -> 7) + (2 -> 9 -> 5) = 617 + 295 = 912
MULTIPLIER = 1
function sum_list_follow_up(list1, list2)
    print('sum_list_follow_up')
    while list1.count ~= list2.count do
        if list1.count < list2.count
        then
            list1:insert_at_front(0)
        else
            list2:insert_at_front(0)
        end
    end

    local result, carry = sum_list_follow_up_helper(list1.head, list2.head)
    result = result + carry * MULTIPLIER
    print('sum2: ' .. result)
end

function sum_with_carry(sub_total)
    local carry = 0
    
    if sub_total >= 10
    then
        carry = 1
        sub_total = sub_total % 10
    end

    return sub_total, carry
end

function sum_list_follow_up_helper(node1, node2)
    if not node1.next and not node2.next
    then
        local sub_total, carry = sum_with_carry(node1.value + node2.value)
        local sum = sub_total * MULTIPLIER

        MULTIPLIER = MULTIPLIER * 10

        return sum, carry
    else
        local sum, carry = sum_list_follow_up_helper(node1.next, node2.next)
        local sub_total, carry = sum_with_carry(node1.value + node2.value + carry)
        sum = sum + sub_total * MULTIPLIER

        MULTIPLIER = MULTIPLIER * 10

        return sum, carry
    end
end

local list1 = LinkedList:new({6, 1, 7})
local list2 = LinkedList:new({2, 9, 5})
sum_list_follow_up(list1, list2)

-- Implement a function that determines if a linked-list is a palindrome.

function list_palindrome(list)
    local slow = list.head
    local fast = list.head
    local stack = Stack:new()

    -- find midpoint
    while fast and fast.next do
        stack:push(slow.value)
        slow = slow.next
        fast = fast.next.next
    end

    if fast -- absolute middle of list (odd number count); go one further
    then
        slow = slow.next
    end

    while slow do
        local value = stack:pop()
        if value ~= slow.value
        then
            return false
        end

        slow = slow.next
    end

    return true
end

local list = LinkedList:new({'R', 'A', 'C', 'E', 'C', 'A', 'R'})
print('Palindrome? ' .. tostring(list_palindrome(list)))

--[[
    Given two (singly) linked lists, determine if the two lists intersect. Return the intersecting
    node. Note that the intersection is defined based on reference, not value. That is, if the kth
    node of the first linked list is the exact same node (by reference) as the jth node of the second
    linked list, then they are intersecting.
]]

function intersect(list1, list2)
    local cache = {}
    local pointer = list1.head
    while pointer do
        cache[pointer] = true

        pointer = pointer.next
    end

    pointer = list2.head
    while pointer do
        if cache[pointer]
        then
            print('intersection at node value: ' .. pointer.value)
            return
        end

        pointer = pointer.next
    end

    print('no intersection...')
end

-- slow/fast pointer approach
function intersect2(list1, list2)
    -- are the tails the same?
    if list1.tail ~= list2.tail
    then
        print('No intersection...')
        return
    end

    local fast = list1.count >= list2.count and list1.head or list2.head
    local slow = list1.count < list2.count and list1.head or list2.head

    for i = 1, math.abs(list1.count - list2.count) do
        fast = fast.next
    end

    while slow and fast do
        if slow == fast
        then
            print('found intersection! ' .. slow.value)
            return
        end

        slow = slow.next
        fast = fast.next
    end

    print('No intersection...')
end

local list1 = LinkedList:new({9, 8, 7, 6, 5, 4, 3, 2, 1})
local list2 = LinkedList:new({1, 2, 3})
local node = list1:find(4)
list2:add_by_node(node)

intersect(list1, list2)
intersect2(list1, list2)

--[[
    Given a circular linked list, implement an algorithm that returns the node
    at the beginning of the loop.

    DEFINITION: 
        Circular linked list: a (corrupt) linked list in which a node's next 
            pointer points to an earlier node, so as to make a loop in the linked list.

    Example:
        INPUT:  A -> B -> C -> D -> E -> C (the same C as earlier)
        OUTPUT: C
]]

function circular(list)
    local slow = list.head
    local fast = list.head

    while fast and fast.next do
        if slow == fast
        then
            break
        end

        slow = slow.next
        fast = fast.next.next
    end

    if not fast or not fast.next
    then
        print('No circular reference...')
        return
    end

    slow = list.head
    while slow ~= fast do
        slow = slow.next
        fast = fast.next
    end

    print('The list has a circular reference!')
end

local list = LinkedList:new({'A', 'B', 'C', 'D', 'E'})
local node = list:find('C')
list:link_end_to_node(node)

circular(list)