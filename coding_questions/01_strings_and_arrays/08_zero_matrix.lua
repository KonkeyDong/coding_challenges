--[[
    Write an algorithm such that if an element in an MxN matrix is 0 (zero),
    its entire row and column are set to 0.
]]

local pretty = require "pl.pretty"
local tablex = require "pl.tablex" -- useful functional techniques. I just wish you could call .import() like on "pl.stringx"
local seq = require "pl.seq" -- iterators (removes creating an index variable and using that to lookup table data; just store the data into the variable)
require "pl.stringx".import()

-- solution 1: do a lookup and store all found zeros into an array.
--      Loop over array and zero out the row/col on separate loops.
--      This works well, but the hash adds extra unnecessary storage.
function find_zero_in_matrix(matrix)
    local lookup_table = {}
    for row = 1, #matrix do
        for col = 1, #matrix[1] do
            if matrix[row][col] == 0
            then
                table.insert( lookup_table, row .. "," .. col )
            end
        end
    end

    return lookup_table
end

-- Note that the original matrix is modified in place
function zero_fill(matrix, lookup_table)
    for coordinate in seq.list(lookup_table) do
        local row, col = table.unpack(
            tablex.imap(tonumber, coordinate:split(','))
        )

        for i = 1, #matrix do
            matrix[i][col] = 0
        end

        for i = 1, #matrix[1] do
            matrix[row][i] = 0
        end
    end
end

function print_matrix(matrix)
    for i in seq.list(matrix) do
        seq.printall(i)
    end
end

local matrix = {
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 0, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
} 

local lookup_table = find_zero_in_matrix(matrix)
zero_fill(matrix, lookup_table)

print_matrix(matrix)
