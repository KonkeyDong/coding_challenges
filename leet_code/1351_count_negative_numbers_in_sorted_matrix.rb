# Given a m x n matrix grid which is sorted in non-increasing order both row-wise and column-wise, return the number of negative numbers in grid.

 

# Example 1:

# Input: grid = [[4,3,2,-1],[3,2,1,-1],[1,1,-1,-2],[-1,-1,-2,-3]]
# Output: 8
# Explanation: There are 8 negatives number in the matrix.
# Example 2:

# Input: grid = [[3,2],[1,0]]
# Output: 0
# Example 3:

# Input: grid = [[1,-1],[-1,-1]]
# Output: 3
# Example 4:

# Input: grid = [[-1]]
# Output: 1
 

# Constraints:

# m == grid.length
# n == grid[i].length
# 1 <= m, n <= 100
# -100 <= grid[i][j] <= 100

# --------

# @param {Integer[][]} grid
# @return {Integer}
def count_negatives(grid)
    count = 0

    grid.each do |row|
        row.each_with_index do |n, i|
            if n < 0
                count += (row.length - i)
                break
            end
        end
    end

    count
end