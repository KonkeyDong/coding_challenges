--[[
    Flip Bit to Win

    You have an integer and you can fiip exactly one bit rom a 0 to a 1.
    Write code to find the length of the longest sequence of 1s you could create.

    Ex:

    Input : 1775 (or: 11011101111)
    Output: 8
]]

local BM = BitManipulations or require 'bit_manipulations'
local dbg = require 'debugger'

-- solution 1: loop over the string once and check the bits
function flip_bit_to_win(number)
    local max = 0
    local previous = 0
    local current = 0
    local binary = BM.decimal_to_binary(number)

    for i = 1, #binary do
        if string.sub(binary, i, i) == '1' then
            current = current + 1
        else
            max = math.max(previous + current + 1, max)
            previous = current
            current = 0
        end
    end

    math.max(previous + current + 1, max)
end

-- solution 2: just use bit manipulations
function flip_bit_to_win2(number)
    local previous = 0
    local current = 0
    local max = 0

    while number ~= 0 do
        -- check if right-most bit is one
        if (number & 1) == 1 then 
            current = current + 1
        else -- current right-most bit is zero
            -- update to 0 (if next bit is 0) or current length
            -- (if next bit is 1)
            previous = (number & 2) == 0 and 0 or current
            current = 0
        end

        max = math.max(previous + current + 1, max)
        number = number >> 1 -- shift bits over 1 (divide number by 2)
    end

    return max
end

local result = flip_bit_to_win2(1775)
print("The longest 1s sequence is: " .. result)
