--- A class for a basic stack (FILO)
-- The backbone of the stack is a double linked list.
-- See linked_list.lua for documentation.
-- @classmod Stack
-- @author KonkeyDong

local Stack = {}
Stack.__index = Stack

local LinkedList = LinkedList or require 'linked_list'

local const = const or require 'constants'
local seq = require "pl.seq"
local List = require "pl.List"
-- local dbg = require 'debugger'

--- Constructor.
-- @param values a table of numeric values.
-- @return Instance of the object.
function Stack:new(values)
    self = setmetatable({ 
        list = LinkedList:new()
    }, Stack)

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            self:push(value)
        end
    end

    return self
end

--- Push (add) a value to the top of the stack.
-- @param value The value to push on top of the stack
function Stack:push(value)
    self.list:insert_at_front(value)
end

--- Pop (remove) a value from the top of the stack and return it.
-- @return The last item pushed onto the stack. If the stack is empty, returns nil.
function Stack:pop()
    if self:is_empty()
    then
        return nil
    end

    local value = self.list.head.value
    self.list:remove_from_front()

    return value
end

--- Peek (view) the most recently pushed value on the stack.
-- @return The last value pushed on the stack. If the stack is empty, returns nil.
function Stack:peek()
    if self:is_empty()
    then
        return nil
    end
        
    return self.list.head.value
end

--- Check if the stack is empty.
-- @return Returns true if the internal count is greater than zero. Otherwise, returns false.
function Stack:is_empty()
    if self.list.count == 0
    then
        return true
    else
        return false
    end
end

--- Get the current stack count.
-- @return the current count of the stack.
function Stack:count()
    return self.list.count
end

--- Get an array representation of the stack.
-- @return A table representing the stack with the first element being the top of the stack (last value pushed).
function Stack:values()
    return self.list:values()
end

return Stack
