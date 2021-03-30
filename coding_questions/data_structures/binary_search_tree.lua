local BinarySearchTree = {}
BinarySearchTree.__index = BinarySearchTree

local seq = require "pl.seq"
-- local dbg = require 'debugger'

local EMPTY = nil

function BinarySearchTree:new(values)
    self = setmetatable({
        count = 0, 
        root = {
            left = EMPTY,
            right = EMPTY,
            value = EMPTY
        }
    }, BinarySearchTree)

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            self:add(value)
        end
    end

    return self
end

function BinarySearchTree:_create_node(value, node, direction)
    node[direction] = {
        left = EMPTY,
        right = EMPTY,
        up = node,
        value = value
    }

    node = setmetatable(node[direction], BinarySearchTree)

    self:_increment_count()
end

function BinarySearchTree:_create_left_node(value, node)
    self:_create_node(value, node, 'left')
end

function BinarySearchTree:_create_right_node(value, node)
    self:_create_node(value, node, 'right')
end

function BinarySearchTree:add(value)
    if self.count == 0
    then
        self.root.value = value
        self.up = EMPTY
        self:_increment_count()
    end

    self:_add_helper(value, self.root)
end

function BinarySearchTree:_add_helper(value, node)
    if not node -- did we find the end of the tree?
    then
        return true
    end

    if not value
    then
        return true
    end

    -- print('value: ' .. tostring(value))
    -- dbg()
    if type(value) ~= 'nil' and value < node.value
    then
        if self:_add_helper(value, node.left)
        then
            self:_create_left_node(value, node)
            return false -- get out of if-statements
        end
    elseif type(value) ~= 'nil' and value > node.value
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
function BinarySearchTree:search(value)
    local node = self:_search_helper(value, self.root)

    return node and node.value or nil
end

function BinarySearchTree:get_node(value)
    local node = self:_search_helper(value, self.root)

    return node and node or nil
end

function BinarySearchTree:_search_helper(value, node)
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

function BinarySearchTree:minimum(node)
    return self:_find_max_or_min('left', node).value
end

function BinarySearchTree:maximum(node)
    return self:_find_max_or_min('right', node).value
end

function BinarySearchTree:_find_max_or_min(direction, node)
    if not node
    then
        return nil
    end

    local pointer = node
    while pointer[direction] do
        pointer = pointer[direction]
    end

    return pointer
end

function BinarySearchTree:delete(value)
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

function BinarySearchTree:_remove_no_leaf_node(node)
    local parent, direction = self:_get_parent_and_child_direction(node)
    parent[direction] = EMPTY
    self:_decrement_count()
end

function BinarySearchTree:_remove_one_leaf_node(node)
    local parent, direction = self:_get_parent_and_child_direction(node)
    local child = self:_one_leaf(node)
    child.up = parent
    parent[direction] = child
    node = EMPTY
    self:_decrement_count()
end

function BinarySearchTree:_get_parent_and_child_direction(node)
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

function BinarySearchTree:_no_leaves(node)
    return (not node.left and not node.right) and true or false
end

function BinarySearchTree:_one_leaf(node)
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

function BinarySearchTree:_two_leaves(node)
    return (node.left and node.right) and true or false
end

-- I opted for just returning data for testing reasons.
-- These functions should be reduced somehow.
function BinarySearchTree:in_order_traversal()
    local data = {}
    self:_in_order_traversal_helper(self.root, data)

    return data
end

function BinarySearchTree:_in_order_traversal_helper(node, data)
    if node
    then
        self:_in_order_traversal_helper(node.left, data)
        table.insert(data, node.value)
        self:_in_order_traversal_helper(node.right, data)
    end
end

function BinarySearchTree:pre_order_traversal()
    local data = {}
    self:_pre_order_traversal_helper(self.root, data)

    return data
end

function BinarySearchTree:_pre_order_traversal_helper(node, data)
    if node
    then
        table.insert(data, node.value)
        self:_pre_order_traversal_helper(node.left, data)
        self:_pre_order_traversal_helper(node.right, data)
    end
end

function BinarySearchTree:post_order_traversal()
    local data = {}
    self:_post_order_traversal_helper(self.root, data)

    return data
end

function BinarySearchTree:_post_order_traversal_helper(node, data)
    if node
    then
        self:_post_order_traversal_helper(node.left, data)
        self:_post_order_traversal_helper(node.right, data)
        table.insert(data, node.value)
    end
end

function BinarySearchTree:sum_node(node)
    if not node
    then
        return 0 -- base case (additive identify property)
    end

    -- Note: caching the value only works if we don't remove any values from the tree.
    -- That will need to be coded up later. For one of my problems, i'm not removing
    -- any data from the tree; this will suffice.
    -- if node.sum
    -- then
    --     return node.sum
    -- end

    local total = node.value + self:sum_node(node.left) + self:sum_node(node.right)
    -- node.sum = total

    return total
end

function BinarySearchTree:_increment_count()
    self.count = self.count + 1
end

function BinarySearchTree:_decrement_count()
    self.count = self.count - 1
end

return BinarySearchTree
