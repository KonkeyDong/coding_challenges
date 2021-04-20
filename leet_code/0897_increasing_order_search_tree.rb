# https://leetcode.com/problems/increasing-order-search-tree/

# Definition for a binary tree node.
# class TreeNode
#     attr_accessor :val, :left, :right
#     def initialize(val = 0, left = nil, right = nil)
#         @val = val
#         @left = left
#         @right = right
#     end
# end
# @param {TreeNode} root
# @return {TreeNode}
def increasing_bst(root)
    data = []
    increasing_bst_helper(root, data)
    root = nil

    node = TreeNode.new(data.shift, nil, nil)
    current = node
    data.each do |num|
        current.right = TreeNode.new(num, nil, nil)
        current = current.right
    end

    node
end

def increasing_bst_helper(root, data)
    return if root.nil?

    increasing_bst_helper(root.left, data)
    data.push(root.val)
    increasing_bst_helper(root.right, data)
end
