--[[
    First Common Ancestor

    Design an algorithm and write code to find the first common ancestor of two nodes in a binary tree.
    Avoid storing additional nodes in a data structure.

    NOTE: this is not necessarily a binary search tree.
]]

local dbg = require 'debugger'
local BinarySearchTree = BinarySearchTree or require 'binary_search_tree'
local tree = BinarySearchTree:new({'A'})
-- tree.root.value = 'A'
tree.root.left = { value = 'B' }
tree.root.right = { value = 'C' }
tree.root.left.left = { value = 'D' }
tree.root.left.right = { value = 'E' }
tree.root.right.left = { value = 'F' }
tree.root.right.left.right = { value = 'G' }

FOUND1 = false
FOUND2 = false
COMMON_ANCESTOR = tree.root.value

function ancestor(root, p, q)
    -- if one or both nodes (p, q) aren't in the tree, we don't have an ancestor!
    if not covers(root, p) or not covers(root, q)
    then
        return nil
    end

    return ancestor_helper(root, p, q)
end

function ancestor_helper(root, p, q)
    -- return root if root is nil, or the root is equal to either p or q
    if not root or root.value == p or root.value == q
    then
        return root.value
    end

    -- check if both nodes are in the left subtree
    local p_on_left = covers(root.left, p)
    local q_on_left = covers(root.left, q)

    -- if one node is on the left while the other is on the right,
    -- return the node that we're currently on.
    if p_on_left ~= q_on_left
    then
        return root.value
    end

    -- traverse left if p is on the left. otherwise, go right
    local child = p_on_left and root.left or root.right -- ternary-like operation 
    return ancestor_helper(child, p, q)
end

-- find if node p is in the binary tree
function covers(root, p)
    if not root then return false end
    if root.value == p then return true end

    return covers(root.left, p) or covers(root.right, p)
end

function display(result)
    print('The common ancestor: ' .. tostring(result))
end

display(ancestor(tree.root, 'B', 'C')) -- A
display(ancestor(tree.root, 'D', 'E')) -- B
display(ancestor(tree.root, 'D', 'X')) -- nil
display(ancestor(tree.root, 'D', 'G')) -- A
