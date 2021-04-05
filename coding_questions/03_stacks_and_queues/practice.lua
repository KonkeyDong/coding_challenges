--[[
    Three in One: Describe how you could use a single array to implement three stacks.
]]

-- Solution 1: an array that is divided into three parts.
--     NOTE: that we could dynamically increase the size of the array if we exceed the upper limit,
--           but i'm not going to worry about it because I found this question to be kind of lame.

local dbg = require 'debugger'

local Custom_Stack = {}
Custom_Stack.__index = Custom_Stack

function Custom_Stack:new()
    -- default array will be of 100 elements
    return setmetatable({
        lower1 = 1,
        upper1 = 33,
        position1 = 1, -- which element is the first stack currently at
        lower2 = 34,
        upper2 = 66,
        position2 = 34,
        lower3 = 67,
        upper3 = 100,
        position3 = 67,
        data = {}
    }, Custom_Stack)
end

function Custom_Stack:push(stack, data)
    if not self:_stack_number_in_bounds(stack)
    then
        return -- don't add any data if out of bounds
    end

    local upper_bound = self:_get_upper(stack)
    local position = self:_get_position(stack)
    if self[position] <= self[upper_bound]
    then
        local index = self[position]
        self.data[index] = data
        self[position] = self[position] + 1
    end
end

function Custom_Stack:pop(stack)
    if not self:_stack_number_in_bounds(stack)
    then
        return -- again, don't do anything
    end

    local lower_bound = self:_get_lower(stack)
    local position = self:_get_position(stack)
    if self[position] >= self[lower_bound]
    then
        local index = self[position] - 1
        local data = self.data[index]
        self.data[index] = nil -- delete
        self[position] = self[position] - 1

        return data
    end
end

function Custom_Stack:peek(stack)
    if not self:_stack_number_in_bounds(stack)
    then
        return -- again, don't do anything
    end

    local lower_bound = self:_get_lower(stack)
    local position = self:_get_position(stack)
    if self[position] >= self[lower_bound]
    then
        local index = self[position] - 1
        return self.data[index]
    end
end

function Custom_Stack:_get_lower(stack)
    return 'lower' .. tostring(stack)
end

function Custom_Stack:_get_upper(stack)
    return 'upper' .. tostring(stack)
end

function Custom_Stack:_get_position(stack)
    return 'position' .. tostring(stack)
end

function Custom_Stack:_stack_number_in_bounds(stack)
    if type(stack) ~= 'number' or stack < 1 or stack > 3
    then
        return false
    else
        return true
    end
end

function Custom_Stack:print()
    for i, v in pairs(self.data) do
        print('Index: ' .. i .. ' | value: ' .. v)
    end
end

local stack = Custom_Stack:new()
-- dbg()
stack:push(1, 'A')
stack:push(2, 'B')
stack:push(3, 'C')
stack:push(4, 'bologna') -- won't happen

stack:print()

print(stack:pop(1)) -- A
print(stack:pop(1)) -- nil
print(stack:pop(2)) -- B

stack:print()
print(stack:peek(3)) -- C

--[[
    Stack Min: how would you design a stack which, in addition to push and pop, has a function
        min() which returns the minimum element? Push(), pop(), and min() should all operate in O(1) time
]]

-- The trick is to use another stack/linked list to store the newest minimum value being pushed to the stack.
-- then, when you call get_minimum() or whatever, it will just return the most recently pushed value on the stack.
-- when popping, if the value you're popping is equal to the minimum stack's top value, then pop that value off the stack.
-- I would code this up, but I already did in my implementation of a stack.

-- Note that this only works on values that are numbers.

--[[
    Stack of Plates:

    Imagine a (literal) stack of plates. If the stack gets too high, it might topple over.
    Therefore, in real life, we would likely start a new stack when the previous stack exceeds
    some threshold. Implement a data structure "SetOfStacks" that mimics this. "SetOfStacks"
    should be composed of several stacks and should create a new stack once the previous one exceeds capacity.

    SetOfStacks.push() and SetOfStacks.pop() should behave identically to a single stack (that is, pop()
    should return the same values as it would if there were just a single stack).

    FOLLOW UP: Implement a function popAt(int index) which performs a pop operation on a specific sub-stack.
        (does that mean return nil if the specific stack is empty, or go to the next lower one??? I guess you
         have to ask your interviewer what they want.)
]]

local Stack = require 'stack'

local StackOfPlates = {}
StackOfPlates.__index = StackOfPlates

function StackOfPlates:new()
    return setmetatable({
        stacks = {
            Stack:new(),
            Stack:new(),
            Stack:new(),
            Stack:new(),
            Stack:new(),

            Stack:new(),
            Stack:new(),
            Stack:new(),
            Stack:new(),
            Stack:new(),
        }, -- 10 stacks in total
        max_size = 3, -- no more than 3 elements per stack!
        current_stack = 1, -- increment/decrement this value to get to the next stack
    }, StackOfPlates)
end

function StackOfPlates:push(data)
    local index = self.current_stack

    if self.stacks[index]:count() < 3 and index <= 10
    then
        local stack = self.stacks[index]
        stack:push(data)
    elseif index > 10
    then
        print('Stack limit reached; nothing to do!')
        return -- don't do anything as we're at our limit!
    elseif self.stacks[index]:count() == 3
    then
        self:_increment_current_stack()
        self:push(data) -- go to next stack
    end
end

function StackOfPlates:pop()
    local index = self.current_stack

    if index > 1
    then
        local value = self.stacks[index]:pop()

        if value
        then
            return value
        else
            self:_decrement_current_stack()
            self:pop()
        end
    end
end

function StackOfPlates:pop_at(index)
    if index < 1 or index > 10
    then
        return
    end

    local data = self.stacks[index]:pop()
    return data
end

function StackOfPlates:_increment_current_stack()
    self.current_stack = self.current_stack + 1
end

function StackOfPlates:_decrement_current_stack()
    self.current_stack = self.current_stack - 1
end


local stack = StackOfPlates:new()
for i = 1, 5 do 
    stack:push(i) 
end

print(tostring(stack:pop())) -- 5
print(tostring(stack:pop_at(1))) -- 3
-- dbg()
print()

--[[
    Queue via Stacks: Implement a MyQueue class which  implements a queue using two stacks.
]]

local MyQueue = {}
MyQueue.__index = MyQueue

function MyQueue:new()
    return setmetatable({
        stack1 = Stack:new(),
        stack2 = Stack:new()
    }, MyQueue)
end

function MyQueue:enqueue(data)
    self.stack1:push(data)
end

function MyQueue:dequeue()
    for i = 1, self.stack1:count() do
        self.stack2:push(self.stack1:pop())
    end

    local data = self.stack2:pop()

    for i = 1, self.stack2:count() do
        self.stack1:push(self.stack2:pop())
    end

    return data
end

local queue = MyQueue:new()
for i = 1, 5 do
    queue:enqueue(i)
end

-- should dequeue in order
print('first --- last')
for i = 1, 5 do
    io.write(tostring(queue:dequeue()) .. ' ')
end
print()

--[[
    Sort Stack:

    Write a program to sort a stack such that the smallest items are on the top. You can
    use an additional temporary stack, but you may not copy the elements into any other data
    structure (such as an array). 
    
    The stack supports the following operations:
    push(), pop(), peek(), and is_empty().
]]

function sort(stack_initial)
    local stack_final = Stack:new()
    local temp = stack_initial:pop()

    while temp or stack_initial:count() > 0 do
        if stack_final:peek() and temp > stack_final:peek()
        then
            stack_initial:push(stack_final:pop())
        else
            stack_final:push(temp)
            temp = stack_initial:pop()
        end
    end

    return stack_final
end

local stack1 = Stack:new({5, 3, 1, 4, 2})
local stack2 = sort(stack1)
print('TOP --- BOTTOM')
for _, v in ipairs(stack2:values()) do
    io.write(v .. ' ')
end
print()
