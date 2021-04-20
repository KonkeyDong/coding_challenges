# https://leetcode.com/problems/n-ary-tree-postorder-traversal/

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
def postorder(root)
    data = []
    postorder_helper(root, data)
    data
end

def postorder_helper(root, data)
    return if root.nil?

    root.children.each do |node|
        postorder_helper(node, data)
    end

    data.push root.val
end
