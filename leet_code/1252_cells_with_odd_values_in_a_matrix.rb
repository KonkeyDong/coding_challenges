# See the URL as there are images:

# https://leetcode.com/problems/cells-with-odd-values-in-a-matrix/

# ------------

# @param {Integer} m
# @param {Integer} n
# @param {Integer[][]} indices
# @return {Integer}
def odd_cells(m, n, indices)
    # note that we used a block to create a 2D array.
    # https://www.thoughtco.com/two-dimensional-arrays-in-ruby-2907737
    matrix = Array.new(m) { Array.new(n, 0) } 

    indices.each do |index|
        row, col = index

        matrix[row].map! { |num| num += 1 }

        for i in 0...(matrix.length) do
            matrix[i][col] += 1
        end
    end

    result = 0
    for row in 0...(matrix.length) do
        result += matrix[row].select { |num| num.odd? }.count
    end

    result
end
