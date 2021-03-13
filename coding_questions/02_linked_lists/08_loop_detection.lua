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

local LinkedList = require 'linked_list'

-- SOLUTION 1: use a hash map to store the reference
function detect_loop(list)
    local set = {}
    local pointer = list.head

    while pointer do
        table_id = tostring(pointer)
        if set[table_id]
        then
            return pointer.value
        else
            set[table_id] = true
        end

        pointer = pointer.next
    end

    return 'false'
end

function display(list, func)
    print('The start of the loop in the list is at node: ' .. func(list))
end

-- SOLUTION 2: use fast/slow pointer approach. No hash necessary (cheaper on space)
function detect_loop2(list)
    local slow = list.head
    local fast = list.head

    -- first, iterate slow/fast until they collide.
    -- If the fast pointer equals nil, there is no loop; exit
    while fast and fast.next do
        slow = slow.next
        fast = fast.next.next

        if slow == fast 
        then 
            break 
        end
    end

    -- check if we don't have a loop
    if fast == nil or fast.next == nil
    then
        return 'false'
    end

    -- now, set slow to head and iterate both pointers until collision.
    -- return either of the nodes as they are the same.
    slow = list.head
    while slow ~= fast do
        slow = slow.next
        fast = fast.next
    end

    return fast.value
end

local list = LinkedList:new({'A', 'B', 'C', 'D', 'E'})
local node = list:find('C')
list:link_end_to_node(node)

display(list, detect_loop2)

local list = LinkedList:new({'Z', 'Y', 'X'})
display(list, detect_loop2)
