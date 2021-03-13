-- Delete Middle Node: Implement an algorithm to delete a node in the middle
-- (i.e., any node but the first and last nodes, not necessarily the middle)
-- of a singly-linked list, given only access to that node.

-- Example:
-- input: node C from the linked list a->b->c->d->e->f
-- result: nothing is returned, but the new list is: a->b->d->e->f

local LinkedList = require 'linked_list'

-- solution 1 using double-linked list as a smart ass
local list = LinkedList:new({'a', 'b', 'c', 'd', 'e', 'f'})
print('solution 1: before')
list:print()

local node = list:find('c')
list:remove_node(node)
print('\nsolution 1: after')
list:print()

-- solution 2 using single-linked list approach.
-- note that the desired node can't be at the end and should be pointed out.
function remove_from_node(node)
    if node == nil or node.next == nil
    then
        return false -- fail
    end

    local next = node.next
    node.value = next.value
    node.next = next.next

    return true
end

local list = LinkedList:new({'a', 'b', 'c', 'd', 'e', 'f'})
print('\nsolution 2: before')
list:print()

print('result: ' .. tostring(remove_from_node(list:find('c')))) -- remove 'c'
print('result: ' .. tostring(remove_from_node(list:find('f')))) -- fail as 'f' is at the end

print('\nsolution 2: after')
list:print()
