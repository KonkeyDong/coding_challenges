# Given a m * n matrix of distinct numbers, return all lucky numbers in the matrix in any order.

# A lucky number is an element of the matrix such that it is the minimum element in its row and maximum in its column.

 

# Example 1:

# Input: matrix = [[3,7,8],[9,11,13],[15,16,17]]
# Output: [15]
# Explanation: 15 is the only lucky number since it is the minimum in its row and the maximum in its column
# Example 2:

# Input: matrix = [[1,10,4,2],[9,3,8,7],[15,16,17,12]]
# Output: [12]
# Explanation: 12 is the only lucky number since it is the minimum in its row and the maximum in its column.
# Example 3:

# Input: matrix = [[7,8],[1,2]]
# Output: [7]
 

# Constraints:

# m == mat.length
# n == mat[i].length
# 1 <= n, m <= 50
# 1 <= matrix[i][j] <= 10^5.
# All elements in the matrix are distinct.

# @param {Integer[][]} matrix
# @return {Integer[]}
def lucky_numbers (matrix)
    result = []

    matrix.each  do |row|
        min_row = row.min
        index = row.find_index(min_row)
        
        max_col = (0...matrix.length).reduce([]) do |array, i|
            array.push(matrix[i][index])

            array
        end.max

        result.push(min_row) if min_row == max_col
    end

    result
end

# I saw this solution on the submission board. Extremely elegant:
# I need to learn that :transpose() method. Seems to rotate
# See this defintion of transpose of a matrix; https://byjus.com/maths/transpose-of-a-matrix/
# it essentially rotates the matrix

# def lucky_numbers (matrix)
#     rows = matrix.map{|x| x.min}
#     col = matrix.transpose.map{|x| x.max}
#     rows & col
# end

lucky_numbers [[1,10,4,2],[9,3,8,7],[15,16,17,12]]
