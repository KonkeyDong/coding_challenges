--[[
    Minimal Tree:

    Given a sorted (increasing order) array with unique integer elements, 
    write an algorithm to create a binary search tree with minimal height.
]]

local BinaryTree = BinaryTree or require 'binary_tree'
TREE = BinaryTree:new()
local dbg = require 'debugger'

local sample = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

function create_minimal_bst(data)
    return create_minimal_bst_helper(data, 1, #data)
end

-- Essentially, if we know the mid point, we can assume to the left of the mid point
-- will be the left side of the tree from the mid point and the right of the mid point
-- will be the right side of the tree. 
-- Remember that arrays in Lua start at 1 and not 0.
function create_minimal_bst_helper(data, start, finish)
    if finish < start
    then
        return nil
    end

    local mid = math.floor((start + finish) / 2)

    -- slower as this requires traversals, but it uses the code i already created.
    -- TREE:add(mid)
    -- TREE:add(create_minimal_bst_helper(data, start, mid - 1))
    -- TREE:add(create_minimal_bst_helper(data, mid + 1, finish))
    -- return mid

    -- faster if we just build the node and return it. Technically a binary search tree.
    local node = { value = mid }
    node.left = create_minimal_bst_helper(data, start, mid - 1)
    node.right = create_minimal_bst_helper(data, mid + 1, finish)

    return node
end

function traverse(data)
    if not data
    then
        return
    end

    traverse(data.left)
    print(data.value)
    traverse(data.right)
end

local result = create_minimal_bst(sample)
-- local x = TREE:in_order_traversal()

traverse(result)

--[[
    Should resemble something like this:

             5
          /     \
        2         8
      /   \      /  \
    1      3    6     9
            \    \      \
             4     7     10
]]