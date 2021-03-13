local BinaryTree = {}
BinaryTree.__index = BinaryTree

local seq = require "pl.seq"
-- local dbg = require 'debugger'

local EMPTY = nil

function BinaryTree:new(values)
    self = setmetatable({
        count = 0, 
        root = {
            left = EMPTY,
            right = EMPTY,
            value = EMPTY
        }
    }, BinaryTree)

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            self:add(value)
        end
    end

    return self
end

function BinaryTree:_create_node(value, node, direction)
    node[direction] = {
        left = EMPTY,
        right = EMPTY,
        up = node,
        value = value
    }

    self:_increment_count()
end

function BinaryTree:_create_left_node(value, node)
    self:_create_node(value, node, 'left')
end

function BinaryTree:_create_right_node(value, node)
    self:_create_node(value, node, 'right')
end

function BinaryTree:add(value)
    if self.count == 0
    then
        self.root.value = value
        self.up = EMPTY
        self:_increment_count()
    end

    self:_add_helper(value, self.root)
end

function BinaryTree:_add_helper(value, node)
    if not node -- did we find the end of the tree?
    then
        return true
    end

    if value < node.value
    then
        if self:_add_helper(value, node.left)
        then
            self:_create_left_node(value, node)
            return false -- get out of if-statements
        end
    elseif value > node.value
    then
        if self:_add_helper(value, node.right)
        then
            self:_create_right_node(value, node)
            return false -- get out of if-statements
        end
    else -- ignore already found nodes
        return false
    end
end

-- I opted for returning value because of this: https://algs4.cs.princeton.edu/32bst/
function BinaryTree:search(value)
    local node = self:_search_helper(value, self.root)

    if node
    then
        return node.value
    else
        return nil
    end
end

function BinaryTree:_search_helper(value, node)
    if not node 
    then 
        return nil 
    end

    if value == node.value
    then
        return node
    elseif value < node.value
    then
        return self:_search_helper(value, node.left)
    else
        return self:_search_helper(value, node.right)
    end
end

function BinaryTree:minimum()
    return self:_find_max_or_min('left', self.root).value
end

function BinaryTree:maximum()
    return self:_find_max_or_min('right', self.root).value
end

function BinaryTree:_find_max_or_min(direction, node)
    local pointer = node
    while pointer[direction] do
        pointer = pointer[direction]
    end

    return pointer
end

function BinaryTree:delete(value)
    local node = self:_search_helper(value, self.root)

    if node
    then
        if self:_no_leaves(node)
        then
            self:_remove_no_leaf_node(node)
            return
        end

        if self:_one_leaf(node)
        then
            self:_remove_one_leaf_node(node)
            return
        end

        if self:_two_leaves(node)
        then
            -- minimum search to the direct right of the current node
            local successor = self:_find_max_or_min('left', node.right)
            node.value = successor.value

            if self:_no_leaves(successor) then self:_remove_no_leaf_node(successor) end
            if self:_one_leaf(successor)  then self:_remove_one_leaf_node(successor) end
            return
        end
    end
end

function BinaryTree:_remove_no_leaf_node(node)
    local parent, direction = self:_get_parent_and_child_direction(node)
    parent[direction] = EMPTY
    self:_decrement_count()
end

function BinaryTree:_remove_one_leaf_node(node)
    local parent, direction = self:_get_parent_and_child_direction(node)
    local child = self:_one_leaf(node)
    child.up = parent
    parent[direction] = child
    node = EMPTY
    self:_decrement_count()
end

function BinaryTree:_get_parent_and_child_direction(node)
    local parent = node.up
    local child = nil

    if parent.left == node
    then
        child = 'left'
    else
        child = 'right'
    end

    return parent, child
end

function BinaryTree:_no_leaves(node)
    if not node.left and not node.right
    then
        return true
    else
        return false
    end
end

function BinaryTree:_one_leaf(node)
    if not node.left
    then
        return node.right
    elseif not node.right
    then
        return node.left
    else
        return false
    end
end

function BinaryTree:_two_leaves(node)
    if node.left and node.right
    then
        return true
    else
        return false
    end
end

-- I opted for just returning data for testing reasons.
-- These functions should be reduced somehow.
function BinaryTree:in_order_traversal()
    local data = {}
    self:_in_order_traversal_helper(self.root, data)

    return data
end

function BinaryTree:_in_order_traversal_helper(node, data)
    if node
    then
        self:_in_order_traversal_helper(node.left, data)
        table.insert(data, node.value)
        self:_in_order_traversal_helper(node.right, data)
    end
end

function BinaryTree:pre_order_traversal()
    local data = {}
    self:_pre_order_traversal_helper(self.root, data)

    return data
end

function BinaryTree:_pre_order_traversal_helper(node, data)
    if node
    then
        table.insert(data, node.value)
        self:_pre_order_traversal_helper(node.left, data)
        self:_pre_order_traversal_helper(node.right, data)
    end
end

function BinaryTree:post_order_traversal()
    local data = {}
    self:_post_order_traversal_helper(self.root, data)

    return data
end

function BinaryTree:_post_order_traversal_helper(node, data)
    if node
    then
        self:_post_order_traversal_helper(node.left, data)
        self:_post_order_traversal_helper(node.right, data)
        table.insert(data, node.value)
    end
end

function BinaryTree:_increment_count()
    self.count = self.count + 1
end

function BinaryTree:_decrement_count()
    self.count = self.count - 1
end

return BinaryTree
