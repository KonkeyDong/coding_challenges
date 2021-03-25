--[[
    Check Subtree:

    T1 and T2 are two very large binary trees, with T1 much bigger than T2.
    Create an algorithm to determine if T2 is a subtree of T1.

    A tree T2 is a subtree of T1 if there exists a node n in T1 such that the
    subtree of n is identical to T2. That is, if you cut off the tree at node n,
    the two trees would be identical.
]]

local BinaryTree = BinaryTree or require 'binary_tree'

local dbg = require 'debugger'

-- solution 1: compare nodes until the data doesn't match.
-- node1 is the node from tree1, and likewise for node2.
function compare_trees(node1, node2)
    if node1 == nil and node2 == nil
    then
        return true
    end

    if node1 and node2 and node1.value == node2.value
    then
        local left = compare_trees(node1.left, node2.left)
        local right = compare_trees(node1.right, node2.right)

        if not left or not right
        then
            return false
        end

        return left == right and true or false
    else
        return false
    end
end

-- solution 2: cleaner, but similar concept as above.
function contains_tree(t1, t2)
    if t2 == nil -- empty trees are always subtrees
    then
        return true
    end

    return subtree(t1.root, t2.root)
end

function subtree(node1, node2)
    if node1 == nil
    then
        return false
    elseif node1.value == node2.value and match_tree(node1, node2) -- compare
    then
        return true
    end

    -- search through tree1 until we have matching data to compare from
    return subtree(node1.left, node2) or subtree(node1.right, node2)
end

function match_tree(node1, node2)
    if node1 == nil and node2 == nil
    then
        return true
    elseif node1 == nil or node2 == nil
    then
        return false
    elseif node1.value ~= node2.value
    then
        return false
    else
        return match_tree(node1.left, node2.left) and match_tree(node1.right, node2.right)
    end
end

function display(node1, node2)
    print('[SOLUTION 1] Tree 1 has a subtree that is Tree 2: ' .. tostring(compare_trees(node1, node2)))
end

function display2(tree1, tree2)
    print('[SOLUTION 2] Tree 1 has a subtree that is Tree2: ' .. tostring(contains_tree(tree1, tree2)))
end

local tree1 = BinaryTree:new({5, 3, 7, 6, 8, 1, 2})
local tree2 = BinaryTree:new({7, 6, 8})
local node1 = tree1:get_node(7)
display(node1, tree2.root) -- true

local tree3 = BinaryTree:new({7, 2, 1})
display(node1, tree3.root) -- false

print()
display2(tree1, tree2)
display2(tree1, tree3)
