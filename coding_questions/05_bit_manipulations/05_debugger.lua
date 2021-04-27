--[[
    Debugger

    Explain what the following code does:

    ((n & (n - 1)) == 0)
]]

-- I believe that this checks if our number contains exactly one bit set.
-- If so, we subtract one from the number and AND both numbers together.
-- If the result is a 0, that means we have exactly one bit set.

--[[
    0100 (4)
 &  0011 (3)
 ------------
    0000 (0)
]]
