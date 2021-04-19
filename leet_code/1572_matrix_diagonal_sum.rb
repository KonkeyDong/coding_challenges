# https://leetcode.com/problems/matrix-diagonal-sum/

# Given a square matrix mat, return the sum of the matrix diagonals.

# Only include the sum of all the elements on the primary diagonal and all the elements on the secondary diagonal that are not part of the primary diagonal.

 

# Example 1:


# Input: mat = [[1,2,3],
#               [4,5,6],
#               [7,8,9]]
# Output: 25
# Explanation: Diagonals sum: 1 + 5 + 9 + 3 + 7 = 25
# Notice that element mat[1][1] = 5 is counted only once.
# Example 2:

# Input: mat = [[1,1,1,1],
#               [1,1,1,1],
#               [1,1,1,1],
#               [1,1,1,1]]
# Output: 8
# Example 3:

# Input: mat = [[5]]
# Output: 5
 

# Constraints:

# n == mat.length == mat[i].length
# 1 <= n <= 100
# 1 <= mat[i][j] <= 100

# ----------

# @param {Integer[][]} mat
# @return {Integer}
def diagonal_sum(mat)
    sum = 0
    len = mat.size
    (0..len-1).each do |i| 
        bottom_right = len-1-i

        a = mat[i][i] 
        b = mat[i][bottom_right]

        sum += a
        sum += b if i != bottom_right
    end
    sum
end
