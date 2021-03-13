local Stack = {}
Stack.__index = Stack

local LinkedList = LinkedList or require 'linked_list'

local seq = require "pl.seq"
local List = require "pl.List"
-- local dbg = require 'debugger'

function Stack:new(values)
    self = setmetatable({ 
        list = LinkedList:new(),
        minimum = LinkedList:new()
    }, Stack)

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            self:push(value)
        end
    end

    return self
end

function Stack:push(value)
    if self:min() == nil or self:min() >= value
    then
        self.minimum:insert_at_front(value)
    end

    self.list:insert_at_front(value)
end

function Stack:pop()
    if self:is_empty()
    then
        return nil
    end

    local value = self.list.head.value
    self.list:remove_from_front()

    if self:min() == value
    then
        self.minimum:remove_from_front()
    end

    return value
end

function Stack:peek()
    if self:is_empty()
    then
        return nil
    end
        
    return self.list.head.value
end

function Stack:is_empty()
    if self.list.count == 0
    then
        return true
    else
        return false
    end
end

function Stack:min()
    if self:is_empty()
    then
        return nil
    end
    
    if self.minimum.count == 0
    then
        self.minimum:push(2 ^ 64)
    end

    return self.minimum.head.value
end

function Stack:count()
    return self.list.count
end

function Stack:values()
    return self.list:values()
end

return Stack
