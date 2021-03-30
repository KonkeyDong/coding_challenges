--[[
    List of Depth:

    Given a binary tree, design an algorithm which creates a linked list of all the nodes at each depth
    (e.g., if you have a tree with depth D, you'll have D linked lists.)
]]

local LinkedList = LinkedList or require 'linked_list'
local BinarySearchTree = BinarySearchTree or require 'binary_tree'
local List = require 'pl.List'

-- local dbg = require 'debugger'

local linked_lists = {} -- store our linked lists. if the depth is 4, expect 4 linked lists
local tree = BinarySearchTree:new({5, 2, 8, 1, 3, 6, 9, 4, 7, 10})


-- Solution 1: build an array of linked lists. Create a new LinkedList once
-- we get to a tree that now now leaves/children. (not the most efficient as you're
-- copying arrays and adding new values to the array, but it works.)

-- After looking at solution 2, I misunderstood what the author wanted. I was thinking you drill
-- down until you hit a leaf with no children and add all values back up to the top into a linked list. 
-- Oh well. Scratch this.
-- function list_of_depth(tree)
--     list_of_depth_helper(tree.root.left, { tree.root.value })
--     list_of_depth_helper(tree.root.right, { tree.root.value })
-- end

-- function list_of_depth_helper(tree, data)
--     local new_data = List.new(data):clone()
--     table.insert( new_data, tree.value )

--     if not tree.left and not tree.right
--     then
--         table.insert(linked_lists, LinkedList:new(new_data))
--         return
--     end
    
--     if tree.left  then list_of_depth_helper(tree.left,  new_data) end
--     if tree.right then list_of_depth_helper(tree.right, new_data) end
-- end

-- solution 2: use a modified Depth-first search

function create_level_linked_list(root)
    lists = { }
    create_level_linked_list_helper(root, lists, 1) -- offset by 1 as arrays start at 1 in lua
    return lists
end

function create_level_linked_list_helper(root, lists, level)
    if root == nil
    then
        return -- base case
    end

    local list = nil
    if #lists + 1 == level -- level not in list
    then
        list = LinkedList:new()
        table.insert(lists, list) -- arrays start at 1; need to use offset to retrieve data correctly.
    else -- level in list; retrieve the list from the lists array
        list = lists[level]
    end

    list:add(root.value)
    create_level_linked_list_helper(root.left, lists, level + 1)
    create_level_linked_list_helper(root.right, lists, level + 1)
end

function display(lists)
    print('number of linked lists: ' .. #lists)
    for depth, list in ipairs(lists) do
        io.write('Depth ' .. depth .. ': ')
        for value in list:iter() do
            io.write(value .. ' ')
        end
        print()
    end
end

list_of_depth(tree)
-- display(linked_lists)

display(create_level_linked_list(tree.root))

