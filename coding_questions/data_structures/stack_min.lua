local const = const or require 'constants'
local seq = require "pl.seq"
local Stack = Stack or require("stack")

local StackMin = setmetatable({}, {__index = Stack})
StackMin.__index = StackMin

function StackMin:new(values)
    self = setmetatable(Stack:new(), StackMin)
    self.minimum = Stack:new()

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            self:push(value)
        end
    end

    return self
end

function StackMin:push(value)
    if self:min() == nil or self:min() >= value
    then
        self.minimum:push(value)
    end

    Stack.push(self, value)
end

function StackMin:pop()
    local value = Stack.pop(self)

    if self:min() == value
    then
        self.minimum:pop()
    end

    return value
end

--- Get the smallest number pushed onto the stack.
-- @return The smallest number on the stack. If the stack is empty, returns nil.
function StackMin:min()
    if self:is_empty()
    then
        return nil
    end
    
    if self.minimum.count == 0
    then
        self.minimum:push(const.INT_MAX)
    end

    return self.minimum:peek()
end

return StackMin
