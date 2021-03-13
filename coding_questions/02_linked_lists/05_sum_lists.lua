--[[
    SUM LISTS: You have two numbers represented by a linked list, where each node contains a single digit.
    The digits are sotred in reverse order, such that the 1's digit is at the head of the list.
    
    Write a function that adds the two numbers and returns the sum as a linked list.

    Example:
    INPUT: (7->1->6) + (5 -> 9 -> 2). That is, 617 + 295
    OUTPUT: 2->1->9. That is, 912

]]

local LinkedList = require 'linked_list'

local stringx = require "pl.stringx"
local dbg = require 'debugger'

function calculate_sub_total_and_carry(sub_total)
    local carry = 0

    if (sub_total >= 10)
    then
        carry = 1
        sub_total = sub_total % 10
    else
        carry = 0
    end

    return sub_total, carry
end

-- solution 1: 2nd grade addition algorithm
function sum(list1, list2)
    local p1 = list1.head
    local p2 = list2.head
    local carry = 0
    local multiplier = 1
    local total = 0

    while p1 and p2 do
        local sub_result = p1.value + p2.value + carry

        sub_total, carry = calculate_sub_total_and_carry(sub_total)

        total = total + sub_result * multiplier
        multiplier = multiplier * 10

        p1 = p1.next
        p2 = p2.next
    end

    -- special case if the lists are different sizes
    local remaining_pointer = get_non_empty_list(p1, p2)
    while remaining_pointer do
        total  = total + (remaining_pointer.value + carry) * multiplier
        carry = 0
        multiplier = multiplier * 10

        remaining_pointer = remaining_pointer.next
    end

    return total + carry * multiplier
end

function get_non_empty_list(node1, node2)
    if node1 ~= nil
    then
        return node1
    else
        return node2
    end
end

function display(list1, list2, func)
    local symbol = ' -> '
    local display_list1 = stringx.join(symbol, list1:values())
    local display_list2 = stringx.join(symbol, list2:values())

    print(display_list1 .. ' + ' .. display_list2 .. ' = ' .. tostring(func(list1, list2)))
end

local list1 = LinkedList:new({7, 1, 6})
local list2 = LinkedList:new({5, 9, 2})

display(list1, list2, sum)
display(LinkedList:new({7, 1, 6}), LinkedList:new({5, 9}), sum) 
display(LinkedList:new({9, 7, 8}), LinkedList:new({6, 8, 5}), sum) 

-- follow up: forward ordering (don't reverse traverse the double-linked list!)
-- INPUT: (6 -> 1 -> 7) + (2 -> 9 -> 5) = 617 + 295 = 912
function sum2(list1, list2)
    MULTIPLIER = 1
    while list1.count ~= list2.count do
        if list1.count < list2.count
        then
            list1:insert_at_front(0)
        else
            list2:insert_at_front(0)
        end
    end

    local result, carry = sum2_helper(list1.head, list2.head)
    return result + carry * MULTIPLIER
end

function sum2_helper(node1, node2)
    if node1.next == nil and node2.next == nil
    then
        local sub_total = (node1.value + node2.value) * MULTIPLIER
        local carry = 0
        
        sub_total, carry = calculate_sub_total_and_carry(sub_total

        MULTIPLIER = MULTIPLIER * 10
        return sub_total, carry
    else
        local sub_result, carry = sum2_helper(node1.next, node2.next)
        sub_total = node1.value + node2.value + carry

        sub_total, carry = calculate_sub_total_and_carry(sub_total)

        local result = sub_result + sub_total * MULTIPLIER 
        MULTIPLIER = MULTIPLIER * 10

        return result, carry
    end
end


display(LinkedList:new({6, 1, 7}), LinkedList:new({2, 9, 5}), sum2)
display(LinkedList:new({6, 1, 7}), LinkedList:new({9, 5}), sum2) 

-- Note: the book doesn't seem to use a concept for a MULTIPLIER variable to store the results,
--       but the author also uses a separate object to retain state between the recursive calls.
--       May need to implement her solution, but my SOLUTION 2 seems to behave like hers. Though,
--       her code is a little cleaner.