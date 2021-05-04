--[[
    Write a recursive function to multiply two positive integers without using the 
        * operator. You can use addition, subtraction, and bit shifting, but you should
        minimize the number of those operations.
]]

local dbg = require("debugger")

-- solution 1: add on each call (slow)
function multiply1(x, y)
    if x <= 0 then
        return 0
    end

    local count = 0
    local i = 1
    while i < x do
        i = i << 1
        count = count + 1
    end
    
    if count > 0 then
        x = x >> count

        return (y << count) + multiply1(x - 1, y)
    else
        return y + multiply1(x - 1, y)
    end
end

-- solution 2: memoize
function multiply2(x, y)
    local bigger =  x > y and x or y
    local smaller = x < y and x or y

    local memo = {}
    return multiply2_helper(smaller, bigger, memo)
end

function multiply2_helper(smaller, bigger, memo)
    if smaller == 0 then
        return 0
    elseif smaller == 1 then
        return bigger
    elseif memo[smaller] and memo[smaller] > 0 then
        return memo[smaller]
    end

    -- compute half. if uneven, compute other half. If even, double it.
    local s = smaller >> 1 -- divide by 2
    local side1 = multiply2_helper(s, bigger, memo)
    local side2 = side1

    if smaller % 2 == 1 then
        side2 = multiply2_helper(smaller - s, bigger, memo)
    end

    -- sum and cache
    memo[smaller] = side1 + side2
    return memo[smaller]
end

function display(x, y, func)
    print(x .. " * " .. y .. " = " .. tostring(func(x, y)))
end

display(7, 7, multiply2)
