local BinarySearchTree = BinarySearchTree or require 'binary_search_tree'
local tree = BinarySearchTree:new({5, 3, 4, 6, 7, 8})

function max_depth(root)
    if not root then
        return 0
    end

    local left = max_depth(root.left)
    local right = max_depth(root.right)

    return math.max( left, right ) + 1
end

local result = max_depth(tree.root)

print("The resulting depth is: " .. result) -- should be 4
