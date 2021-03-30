--[[
    Check Balanced:

    Implement a function to check if a binary tree is balanced. For the purposes of this question,
    a balanced tree is defined to be a tree such that the heights of the two subtrees of any node
    never differ by more than one.
]]

local BinarySearchTree = BinarySearchTree or require 'binary_tree'
local List = require 'pl.List'
local const = const or require 'constants'
-- local dbg = require 'debugger'

-- Solution 1: recurse down and check heights on each node (slightly less efficient than solution 2, but it works)
function check_balance(root)
    local left = depth(root.left)
    local right = depth(root.right)
    local result = math.abs(left - right)

    return (result <= 1)
end

function depth(node)
    if not node
    then
        return 0
    end

    local left = 1 + depth(node.left)
    local right = 1 + depth(node.right)
    local max = math.max(left, right)
    return max
end

function display(tree)
    print('Is the tree balanced? ' .. tostring(check_balance2(tree.root)))
end

-- solution 2: Check if the tree is balanced at the same time as we're checking heights.
function check_balance2(root)
    print()
    return check_height(root) ~= const.INT_MIN
end

function check_height(root)
    if root == nil
    then
        return -1
    end
    
    local left_height = check_height(root.left)
    if left_height == const.INT_MIN
    then
        return const.INT_MIN
    end
    
    local right_height = check_height(root.right)
    if right_height == const.INT_MIN
    then
        return const.INT_MIN
    end
    
    local height_difference = math.abs(left_height - right_height)
    print('left: ' .. left_height .. ' | right_height: ' .. right_height)
    if height_difference > 1
    then
        return const.INT_MIN
    else
        return math.max(left_height, right_height) + 1
    end
end


local tree = BinarySearchTree:new({1, 2, 3})
display(tree) -- false

local tree = BinarySearchTree:new({5, 3, 7, 2, 4, 6, 8, 1, 9})
display(tree) -- true

local tree = BinarySearchTree:new({5, 3, 7, 2, 4, 6, 8, 9})
display(tree) -- true

local tree = BinarySearchTree:new({5, 3, 8, 2, 4, 7, 9, 6, 10}) -- right side will have 1 depth longer than the left
display(tree) -- true
