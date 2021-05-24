# Given an integer n, return an array ans of length n + 1 such that for each i (0 <= i <= n), ans[i] is the number of 1's in the binary representation of i.

 

# Example 1:

# Input: n = 2
# Output: [0,1,1]
# Explanation:
# 0 --> 0
# 1 --> 1
# 2 --> 10
# Example 2:

# Input: n = 5
# Output: [0,1,1,2,1,2]
# Explanation:
# 0 --> 0
# 1 --> 1
# 2 --> 10
# 3 --> 11
# 4 --> 100
# 5 --> 101
 

# Constraints:

# 0 <= n <= 105
 

# Follow up:

# It is very easy to come up with a solution with a runtime of O(n log n). Can you do it in linear time O(n) and possibly in a single pass?
# Could you solve it in O(n) space complexity?
# Can you do it without using any built-in function (i.e., like __builtin_popcount in C++)?

# @param {Integer} n
# @return {Integer[]}
def count_bits(n)
    (0..n).each_with_object([0]) do |num, cache|
        # very clever solution I found from the submission boards.
        # work by hand to see how this works!
        cache[num] = cache[num / 2] + ( num % 2)
    end
end
