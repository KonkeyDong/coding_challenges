# https://leetcode.com/problems/n-ary-tree-preorder-traversal/

# ----------

# Definition for a Node.
# class Node
#     attr_accessor :val, :children
#     def initialize(val)
#         @val = val
#         @children = []
#     end
# end

# @param {Node} root
# @return {List[int]}
def preorder(root)
    data = []
    preorder_helper(root, data)
    data
end

def preorder_helper(root, data)
    return if root.nil?

    data.push(root.val)
    root.children.each do |node|
        preorder_helper(node, data)
    end
end
