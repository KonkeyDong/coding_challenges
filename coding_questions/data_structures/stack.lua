local Stack = {}
Stack.__index = Stack

local path = require 'pl.path'.abspath('.')
package.path = package.path .. ';' .. path .. '/?.lua'
local LinkedList = LinkedList or require 'linked_list'

local seq = require "pl.seq"
-- local dbg = require 'debugger'

function Stack:new(values)
    self = setmetatable({ list = LinkedList:new() }, Stack)

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            self:push(value)
        end
    end

    return self
end

function Stack:push(value)
    self.list:insert_at_front(value)
end

function Stack:pop()
    if self:is_empty()
    then
        return nil
    end

    local value = self.list.tail.value
    self.list:remove_from_front()

    return value
end

function Stack:peek()
    if self:is_empty()
    then
        return nil
    end
        
    return self.tail.value
end

function Stack:is_empty()
    if self.list.count == 0
    then
        return true
    else
        return false
    end
end

function Stack:count()
    return self.list.count
end

function Stack:values()
    return self.list:values()
end

return Stack
