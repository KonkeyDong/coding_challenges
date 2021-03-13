--[[
    Stack Min: how would you design a stack which, in addition to push and pop, has a function
        min() which returns the minimum element? Push(), pop(), and min() should all operate in O(1) time
]]

local Stack = Stack or require 'stack'

-- Solution 1: cache the result (breaks the O(1) of push/pop)
-- Solution 2: use a separate stack to store min values. Keep in mind that 
--      that the min won't change that often.
local stack = Stack:new({1, 2, 3})
print('minimum value is: ' .. tostring((stack:min())))
