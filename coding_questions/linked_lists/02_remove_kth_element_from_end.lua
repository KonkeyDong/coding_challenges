-- Return the kth node from the end: implement an algorithm to return the kth node from the end

local dbg = require 'debugger'

local path = require 'pl.path'.abspath('../data_structures')
package.path = package.path .. ';' .. path .. '/linked_list.lua'
local LinkedList = require 'data_structures.linked_list'

function kth_from_last(list, k)
    local pointer = list.tail
    -- local length = list.count - k
    for i = 0, k - 1 do
        pointer = pointer.prev
    end

    return pointer
end

function display(message, list, k, func)
    local node = func(list, k)
    print(message .. ' k = ' .. k .. ' | value = ' .. node.value)
end

-- Solution 1 with double-linked lists (if size is known)
-- 0 = 'f', 1 = 'e', 2 = 'd', etc.
local list = LinkedList:new({'a', 'b', 'c', 'd', 'e', 'f'})
display('solution 1:', list, 1, kth_from_last) -- e

display('solution 2:', list, 0, kth_from_last) -- f

-- solution 2: recursion (size is known
function kth_from_last2(list, k)
    return kth_from_last2_helper(list.head, list.count - k - 1)
end

function kth_from_last2_helper(node, k)
    if k <= 0
    then
        return node
    end

    return kth_from_last2_helper(node.next, k - 1)
end

local list = LinkedList:new({'a', 'b', 'c', 'd', 'e', 'f'})
display('solution 2:', list, 1, kth_from_last2) -- e

-- solution 3: iteration with two pointers (slightly less straightforward, but highly optimal)
function kth_from_last3(list, k)
    -- first, iterate first pointer by k
    local pointer = list.head
    for i = 0, k do
        pointer = pointer.next
    end

    -- now, iterate both pointers. when the faster pointer is nil, return current
    local current = list.head
    while pointer do
        pointer = pointer.next
        current = current.next
    end

    return current
end

display('solution 3:', list, 1, kth_from_last3) -- e
display('solution 3:', list, 0, kth_from_last3) -- f
display('solution 3:', list, 2, kth_from_last3) -- d
