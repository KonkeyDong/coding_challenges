# The Hamming distance between two integers is the number of positions at which the corresponding bits are different.

# Given two integers x and y, return the Hamming distance between them.

 

# Example 1:

# Input: x = 1, y = 4
# Output: 2
# Explanation:
# 1   (0 0 0 1)
# 4   (0 1 0 0)
#        ↑   ↑
# The above arrows point to positions where the corresponding bits are different.
# Example 2:

# Input: x = 3, y = 1
# Output: 1
 

# Constraints:

# 0 <= x, y <= 231 - 1

# ----------

# @param {Integer} x
# @param {Integer} y
# @return {Integer}
def hamming_distance(x, y)
    x_b = x.to_s(2)
    y_b = y.to_s(2)
    max_length = [x_b.length, y_b.length].max
    x_b = x_b.rjust(max_length, "0")
    y_b = y_b.rjust(max_length, "0")

    distance = 0
    for i in 0...(x_b.length) do
        distance += 1if x_b[i] != y_b[i]
    end

    distance
end
