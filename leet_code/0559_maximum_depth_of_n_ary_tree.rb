# https://leetcode.com/problems/maximum-depth-of-n-ary-tree/

# Definition for a Node.
# class Node
#     attr_accessor :val, :children
#     def initialize(val)
#         @val = val
#         @children = []
#     end
# end

# @param {Node} root
# @return {int}
def maxDepth(root)
    return 0 if root.nil?
    return 1 if root && root.children.empty?

    maxDepthHelper(root)
end

def maxDepthHelper(root)
    return 1 if root.children.empty?

    data = []
    root.children.each do |node|
        result = maxDepth(node)
        data.push(result + 1)
    end

    data.max
end
