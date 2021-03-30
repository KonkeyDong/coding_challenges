--[[
    BST Sequence:

    A binary search tree was created by traversing through an array from left to right and
    inserting each element. Given a binary search tree with distinct elements, print all
    possible arrays that could have led to this tree.
]]

-- local dbg = require 'debugger'

local BinarySearchTree = BinarySearchTree or require 'binary_tree'
local LinkedList = LinkedList or require 'linked_list'
local tree = BinarySearchTree:new({2, 1, 3})

function traverse(node)
    local result = {}

    if not node
    then
        table.insert( result, LinkedList:new() )
        return result
    end

    local prefix = LinkedList:new({ node.value })

    -- traverse through left and right trees
    local left_sequence = traverse(node.left)
    local right_sequence = traverse(node.right)

    -- weave together each list from the left and right sides
    for _, left in ipairs(left_sequence) do
        for _, right in ipairs(right_sequence) do 
            local weaved = { LinkedList:new() } -- array of linked lists
            weave_lists(left, right, weaved, prefix)
            
            -- add all linked lists to the result array...
            for _, list in ipairs(weaved) do
                -- ... but only if the linked list has any data!
                if list.count > 0
                then
                    table.insert(result, list)
                end
            end
        end
    end

    return result
end

function weave_lists(first, second, results, prefix)
    -- we found linked list that is empty...
    if first.count == 0 or second.count == 0
    then
        -- ... create a copy of all the linked lists "stitched" together and add that linked list to the result array
        local result = LinkedList:new(prefix:values()) + first + second
        table.insert(results, result)
        return
    end
    
    -- recurse with head of first linked list by adding to prefix. Since we're being destructive,
    -- we need to make sure that we put everything back before movin to the second linked list
    local head_first = first.head.value
    first:remove_from_front()
    prefix:add(head_first)
    weave_lists(first, second, results, prefix)
    prefix:remove_from_back()
    first:insert_at_front(head_first)

    -- same as above, but with the second linked list.
    local head_second = second.head.value
    second:remove_from_front()
    prefix:add(head_second)
    weave_lists(first, second, results, prefix)
    prefix:remove_from_back()
    second:insert_at_front(head_second)
end

local result = traverse(tree.root) -- {{2, 1, 3}, {2, 3, 1}
print()
