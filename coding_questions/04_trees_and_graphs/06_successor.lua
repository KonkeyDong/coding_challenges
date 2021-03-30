--[[
    Successor:

    Write an algorithm to find the "next" node (i.e., in-order successor) of a given
    node in a binary search tree. You may assume that each node has a link to its parent.
]]

local BinarySearchTree = BinarySearchTree or require 'binary_tree'
-- local dbg = require 'debugger'

-- I'll admit, i didn't really understand the point of this question or what the author wanted....
function find_next(root)
    if not root
    then
        return nil
    end

    if root.right
    then
        return root.right:minimum(root.right)
    else
        local parent = root
        local child = parent.up
        while child and child.left ~= parent do
            parent = child
            child = child.up
        end

        return child
    end
end

local tree = BinarySearchTree:new({5, 3, 7, 1, 2, 4, 6, 8, 9, 10})
print(find_next(tree.root))
