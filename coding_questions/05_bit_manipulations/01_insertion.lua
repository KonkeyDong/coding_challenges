--[[
    Insertion

    You are given two 32-bit numbers, N and M, and two bit positions, i and j.
    Write a method to insert M into N such that M starts at bit j and ends a bit i.
    You can assume that the bits j through i have enough space to fit all of M. That is,
    if M = 10011, you can assume that there are at least 5 bits between j and i. You would not,
    for example, have j = 3 and i = 2, mecause M could not fully fit between bit 3 and bit 2.

    EX:
    INPUT : N = 10000000000, M = 10011, i = 2, j = 6
                    j   i  
    OUTPUT: N = 10001001100
]]

local BitManipulations = BitManipulations or require 'bit_manipulations'
-- local dbg = require 'debugger'

-- Solution 1: use a loop (slower)
function insert(n, m, lower, upper)
    for i = lower, upper + 1 do
        local bit = BitManipulations.get_bit(m, i - lower)
        n = BitManipulations.update_bit(n, i, bit)
    end

    return BitManipulations.decimal_to_binary(n)
end

-- Solution 2: Using masks
function insert2(n, m, lower, upper)
    local BM = BitManipulations -- alias
    local mask = BM.clear_bits_in_range_mask(32, lower, upper)

    -- clear bits i through j then put m in there

    -- clear bits j through i
    --   10000000000
    -- & 11110000011
    -- --------------
    --   10000000000
    local n_cleared = n & mask 


    -- move m into correct position
    --    10011
    -- <<     2
    -- ---------
    --  1001100 (add two zeros to the right side)
    local m_shifted = m << lower

    -- OR them
    --   10000000000
    -- | 00001001100
    -- --------------
    --   10001001100
    return n_cleared | m_shifted -- OR them, and done
end

local n = 1024
local m = 19
local i = 2
local j = 6

local result = insert2(n, m, i, j)
local result_dec = BitManipulations.decimal_to_binary(result)

print("n: " .. n .. " | m: " .. m .. " | i: " .. i .. " | j: " .. j .. " | result: " .. result .. " | result (dec): " .. tostring(result_dec))
