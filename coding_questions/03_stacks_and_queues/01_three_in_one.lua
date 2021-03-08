--[[
    Three in One: Describe how you could use a single array to implement three stacks.
]]

-- Solution 1: an array that is divided into three parts.
--     NOTE: that we could dynamically increase the size of the array if we exceed the upper limit,
--           but i'm not going to worry about it because I found this question to be kind of lame.

local Stack = {}
Stack.__index = Stack

local seq = require "pl.seq"
local pretty = require 'pl.pretty'
local math = require 'math'
local dbg = require 'debugger'

function Stack:new(size)
    size = size * 3
    local array = {}
    for i = 1, #array do
        array[i] = false
    end

    return setmetatable({
        size = size,
        array = array,
        [1] = 1,                            -- stack 1 start
        [2] = math.floor(size / 3 + 1),     -- stack 2 start
        [3] = math.floor(2 * size / 3 + 1), -- stack 3 start

        ['1_lower'] = 1,
        ['2_lower'] = math.floor(size / 3 + 1),
        ['3_lower'] = math.floor(2 * size / 3 + 1),

        ['1_upper'] = math.floor(size / 3),
        ['2_upper'] = math.floor(2 * size / 3),
        ['3_upper'] = size
    }, Stack)
end

function Stack:push(stack_number, value)
    if self:_not_in_range(stack_number)
    then 
        return nil 
    end

    -- if self:_above_upper_bounds(stack_number)
    -- then

    -- end

    self:_set_value(stack_number, value)
    self:_increment_stack(stack_number)
end

function Stack:pop(stack_number)
    if self:_not_in_range(stack_number) or self:_below_lower_bounds(stack_number)
    then 
        return nil 
    end

    dbg()
    self:_decrement_stack(stack_number)
    local index = self[stack_number]
    local result = self.array[index]
    self:_set_value(stack_number, nil)

    return result
end

function Stack:_build_key(stack_number, postfix)
    return tostring(stack_number) .. postfix
end

function Stack:_above_upper_bounds(stack_number)
    local key = self:_build_key(stack_number, '_upper')

    if self[stack_number] >= self[key]
    then
        return true
    else
        return false
    end
end

function Stack:_below_lower_bounds(stack_number)
    local key = self:_build_key(stack_number, '_lower')

    if self[stack_number] <= self[key]
    then
        return true
    else
        return false
    end
end

function Stack:_set_value(stack_number, value)
    local stack = self[stack_number]
    self.array[stack] = value
end

function Stack:_increment_stack(stack_number)
    self[stack_number] = self[stack_number] + 1
end

function Stack:_decrement_stack(stack_number)
    self[stack_number] = self[stack_number] - 1
end

function Stack:_not_in_range(stack_number)
    if stack_number < 1 and stack_number > 3
    then
        return true
    else
        return false
    end
end

function Stack:peek(stack_number)
    if self:_below_lower_bounds(stack_number)
    then
        return nil
    end

    local index = self[stack_number] - 1
    return self.array[index]
end

local stack = Stack:new(100)

stack:push(1, 'A')
stack:push(2, 'B')
stack:push(3, 'C')
stack:push(1, 'D')

-- dbg()
-- print('result: ' .. tostring(stack:pop(1)))
print('result of peek: ' .. stack:peek(1))
print('result of peek: ' .. stack:peek(2))
print('result of peek: ' .. stack:peek(3))

pretty.dump(stack)
