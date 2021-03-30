--[[
    Validate BST:

    Implement a function to check if a binary tree is a binary search tree.
]]

local BinarySearchTree = BinarySearchTree or require 'binary_tree'

-- solution 1: since we're checking for a binary search tree, all left nodes should be smaller than
--             all right nodes. So, we send a min and max variable and update the variable depending
--             on which direction we traverse. max = left.value ; min = right.value
function check_tree(root, min, max)
    if not root
    then
        return true
    end

    if (min and min >= root.value) or (max and max <= root.value)
    then
        return false
    end

    if not check_tree(root.left, min, root.value) or not check_tree(root.right, root.value, max)
    then
        return false
    end

    return true
end

function display(root)
    print('Is a BST: ', tostring(check_tree(root, nil, nil)))
end

local tree = BinarySearchTree:new({5, 3, 7, 1, 2, 4, 6, 8, 9, 10})
display(tree.root) -- true

local tree = BinarySearchTree:new({5, 3, 7, 1, 2, 4, 6, 8, 9, 10})
tree.root.left.left.value = INT_MAX -- change a random left-side value to a large number to see if this algorithm works
display(tree.root) -- false
