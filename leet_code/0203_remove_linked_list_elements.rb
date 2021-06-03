# see url: https://leetcode.com/problems/remove-linked-list-elements/

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end
# @param {ListNode} head
# @param {Integer} val
# @return {ListNode}
def remove_elements(head, val)
    # remove leading vals
    while head && head.val == val do
        head = head.next
    end

    # now, get the rest of the vals
    current = head
    while current && current.next do
        while current.next && current.next.val == val do
            current.next = current.next.next
        end

        current = current.next
    end

    head
end

# the above method is slightly more memory efficient.
# if you don't care about conserving memory, you could do something like this:

# queue = []
# ptr = head
# while ptr do
#     queue.push ptr.val if ptr.val != val

#     ptr = ptr.next
# end

# ptr = ListNode.new
# queue.each do |item|
#     ptr.val = item
#     ptr.next = ListNode.new

#     ptr = ptr.next
# end
