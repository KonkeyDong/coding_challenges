local Queue = {}
Queue.__index = Queue

local path = require 'pl.path'.abspath('.')
package.path = package.path .. ';' .. path .. '/?.lua'
local LinkedList = LinkedList or require 'linked_list'

local seq = require "pl.seq"
-- local dbg = require 'debugger'

function Queue:new(values)
    self = setmetatable({ list = LinkedList:new() }, Queue)

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            self:add(value)
        end
    end

    return self
end

function Queue:add(value)
    self.list:add(value)
end

function Queue:remove()
    if self:is_empty()
    then
        return nil
    end

    local result = self.list.head.value
    self.list:remove_from_front()

    return result
end

function Queue:peek()
    if self:is_empty()
    then
        return nil
    end

    return self.list.head.value
end

function Queue:is_empty()
    if self:count() == 0
    then
        return true
    else
        return false
    end
end

function Queue:count()
    return self.list.count
end

function Queue:values()
    return self.list:values()
end

return Queue
