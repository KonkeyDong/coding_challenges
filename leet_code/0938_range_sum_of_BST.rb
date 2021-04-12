# See the URL as there are images for the examples: 

# https://leetcode.com/problems/range-sum-of-bst/

# ------------

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
# @param {Integer} low
# @param {Integer} high
# @return {Integer}
def range_sum_bst(root, low, high)
    if root == nil
        return 0
    end
    
    amount = nil
    if root.val >= low && root.val <= high
        amount = root.val
    else
        amount = 0
    end

    # puts root.val

    return amount + 
    range_sum_bst(root.left, low, high) + 
    range_sum_bst(root.right, low, high)
end
