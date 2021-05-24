# Write a function that reverses a string. The input string is given as an array of characters s.

 

# Example 1:

# Input: s = ["h","e","l","l","o"]
# Output: ["o","l","l","e","h"]
# Example 2:

# Input: s = ["H","a","n","n","a","h"]
# Output: ["h","a","n","n","a","H"]
 

# Constraints:

# 1 <= s.length <= 105
# s[i] is a printable ascii character.
 

# Follow up: Do not allocate extra space for another array. You must do this by modifying the input array in-place with O(1) extra memory.

# @param {Character[]} s
# @return {Void} Do not return anything, modify s in-place instead.
def reverse_string(s)
    mid_point = (s.length / 2).to_i
    f = s.length - 1
    s.each_with_index do |char, i|
        break if i >= mid_point

        s[i], s[f - i] = s[f - i], s[i]
    end

    s
end


# the wise-ass solution:
# s.reverse
# but, this fails the follow up where we can't allocate an additional array!