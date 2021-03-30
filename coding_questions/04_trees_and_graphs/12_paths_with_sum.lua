--[[
    Paths with Sum:

    You are given a binary tree in which each node contains an integer value (which might be positive or negative).
    Design an algorithm to count the number of paths that sum to a given value. The path does not need to start 
    or end at the root or a leaf, but it must go downwards (traveling only from parent nodes to child nodes).
]]

local BinarySearchTree = BinarySearchTree or require 'binary_search_tree'
local dbg = require 'debugger'

-- I need to re-implement my design of a binary tree so each node is an instance of the class.
-- This way, I can avoid passing a tree instance around. 

-- Solution 1: brute force
function sum_tree(node, target)
    if not node
    then
        return 0
    end
    
    local paths_from_root = count_paths_with_sum_from_node(node, target, 0)

    local paths_on_left = sum_tree(node.left, target)
    local paths_on_right = sum_tree(node.right, target)

    return paths_from_root + paths_on_left + paths_on_right
end

function count_paths_with_sum_from_node(node, target, current_sum)
    if not node
    then
        return 0
    end

    local current_sum = current_sum + node.value

    local total_paths = 0
    if current_sum == target
    then
        print('current_sum: ' .. current_sum .. ' | target: ' .. target .. ' | node.value: ' .. node.value)
        total_paths = total_paths + 1
    end

    total_paths = total_paths + count_paths_with_sum_from_node(node.left, target, current_sum)
    total_paths = total_paths + count_paths_with_sum_from_node(node.right, target, current_sum)

    return total_paths
end

function display(tree, end_goal, func)
    local result = func(tree.root, end_goal)
    print('Number of paths counting to sum [' .. end_goal .. ']: ' .. tostring(result))
end

-- solution 2: optimized using a hash table lookup: runningSum_x = runningSum_y - target_sum
-- Runs in: O(n)
function count_path_with_sum(node, target_sum)
    return count_paths_with_sum(node, target_sum, 0, {})
end

--[[
    running_sum = current_sum when recursing.
    Using the numbers below, and going left, we have the following sequence:
    10 -> 5 -> 3 -> 3

    Storing the sequence in the hash table would look like this:

      index: 0   1  2  3
      value: 10  5  3  3
    sum/key: 10 15 18 21

    The value of sum at index 2 is 18. If the target is 8,
    Then subtract 8 from 18. 18 - 8 = 10. We have a key in the hash
    table that is 10 and it contains the number 1 (meaning one path).
    Because of this, you can sum the total to the target by starting where
    10 is in the hash index and add 1. So, we start at index 1 and starting
    summing. 5 + 3 = 8 and 8 = target. We have a path that adds to the target!

    Let's try going right this time:

      index: 0  1  2
      value: 10 -3 11
    sum/key: 10  7 18

    [2] = 18
    18 - 8 (target) = 10
    10 is found in the hash table!
    -3 + 11 = 8; path found!

    Very interesting way to look for paths that add to the sum!
--]]

function count_paths_with_sum(node, target_sum, running_sum, path_count)
    if not node
    then
        return 0 -- base case
    end

    running_sum = running_sum + node.value
    local sum = running_sum - target_sum -- The equation that makes this work
    local total_paths = path_count[sum] or 0 -- default to zero if no key/value

    -- found a path that adds to the target sum FROM root.
    if running_sum == target_sum
    then
        total_paths = total_paths + 1
    end

    increment_hash_table(path_count, running_sum, 1) -- increment the hash table
    total_paths = total_paths + count_paths_with_sum(node.left, target_sum, running_sum, path_count)
    total_paths = total_paths + count_paths_with_sum(node.right, target_sum, running_sum, path_count)
    increment_hash_table(path_count, running_sum, -1) -- decrement; backs out of work and prevents other nodes from using as it is no longer needed.

    return total_paths
end

function increment_hash_table(hash_table, key, delta)
    local new_count = (hash_table[key] or 0) + delta

    if new_count == 0
    then
        hash_table[key] = nil -- delete
    else
        hash_table[key] = new_count
    end
end

local tree = BinarySearchTree:new({10})
tree.root.value = 10

local node = tree.root
tree:_create_left_node(5, node)
tree:_create_right_node(-3, node)

local node = tree.root.left
tree:_create_left_node(3, node)
tree:_create_right_node(2, node)

local node = tree.root.right
tree:_create_right_node(11, node)

local node = tree.root.left.left
tree:_create_left_node(3, node)
tree:_create_right_node(-2, node)

local node = tree.root.left.right
tree:_create_right_node(1, node)

-- 8 = 5 + 2 + 1 || 5 + 3 || (-3) + 11
display(tree, 8, sum_tree)
display(tree, 8, count_path_with_sum)