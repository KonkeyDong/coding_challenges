--[[
    Stack of Plates:

    Imagine a (literal) stack of plates. If the stack gets too high, it might topple over.
    Therefore, in real life, we would likely start a new stack when the previous stack exceeds
    some threshold. Implement a data structure "SetOfStacks" that mimics this. "SetOfStacks"
    should be composed of several stacks and should create a new stack once the previous one exceeds capacity.

    SetOfStacks.push() and SetOfStacks.pop() should behave identically to a single stack (that is, pop()
    should return the same values as it would if there were just a single stack).

    FOLLOW UP: Implement a function popAt(int index) which performs a pop operation on a specific sub-stack.
]]

local SetOfStacks = {}
SetOfStacks.__index = SetOfStacks

local path = require 'pl.path'.abspath('../data_structures')
package.path = package.path .. ';' .. path .. '/?.lua'
local Stack = Stack or require 'stack'

local seq = require "pl.seq"
local List = require "pl.List"
local dbg = require 'debugger'

function SetOfStacks:new()
    self = setmetatable({
        upper_limit = 3,
        stacks = { Stack:new() },
    }, SetOfStacks)

    return self
end

function SetOfStacks:push(value)
    if self:_is_full_stack()
    then
        table.insert(self.stacks, Stack:new({value}))
    else
        local index = self:_newest_stack()
        self.stacks[index]:push(value)
    end
end

function SetOfStacks:pop()
    local index = self:_newest_stack()
    return self:pop_at(index)
end

function SetOfStacks:pop_at(index)
    if self:_is_empty_stack()
    then
        self.stacks[index] = nil -- delete stack
        index = index - 1
    end
    
    if index == 0
    then
        return nil
    end

    return self.stacks[index]:pop()
end

function SetOfStacks:_is_full_stack()
    local index = self:_newest_stack()
    if self.stacks[index]:count() == self.upper_limit
    then
        return true
    else
        return false
    end
end

function SetOfStacks:_is_empty_stack()
    local index = self:_newest_stack()
    if self.stacks[index]:count() == 0
    then
        return true
    else
        return false
    end
end

function SetOfStacks:_newest_stack()
    return #self.stacks
end

local stacks = SetOfStacks:new()
stacks:push(1)
stacks:push(2)
stacks:push(3)
stacks:push(4)

print(stacks:pop_at(1)) -- 3
print(stacks:pop()) -- 4
print(stacks:pop()) -- 2
print(stacks:pop()) -- 1
print(stacks:pop()) -- nil
print('test')
