--- A class for a basic queue (FIFO)
-- The backbone of the queue is a double linked list.
-- See linked_list.lua for documentation.
-- @classmod Queue
-- @author KonkeyDong

local Queue = {}
Queue.__index = Queue

local LinkedList = LinkedList or require 'linked_list'

local seq = require "pl.seq"
-- local dbg = require 'debugger'

--- Constructor.
-- @param values A table of values (numeric or string).
-- @return Instance of the object.
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

--- Add (enqueue) a value to the back of the queue in FIFO order.
-- @param value A numeric or string value.
function Queue:add(value)
    self.list:add(value)
end

--- Remove (dequeue) a value from the front of the queue in FIFO order.
-- @return The first item currently in the queue. If the queue is empty, nil is returned.
function Queue:remove()
    if self:is_empty()
    then
        return nil
    end

    local result = self.list.head.value
    self.list:remove_from_front()

    return result
end

--- Peek at the first item in the queue but don't remove (dequeue) it.
-- @return The first item currently in the queue. If the queue is empty, nil is returned.
function Queue:peek()
    if self:is_empty()
    then
        return nil
    end

    return self.list.head.value
end

--- Checks if the queue is empty.
-- @return Returns true if the internal count is greater than zero. Otherwise, returns false.
function Queue:is_empty()
    if self:count() == 0
    then
        return true
    else
        return false
    end
end

--- Get the current queue count.
-- @return The current count of the queue.
function Queue:count()
    return self.list.count
end

--- Get an array representation of the queue.
-- @return A table representing the queue with the first element being the front of the queue.
function Queue:values()
    return self.list:values()
end

return Queue
