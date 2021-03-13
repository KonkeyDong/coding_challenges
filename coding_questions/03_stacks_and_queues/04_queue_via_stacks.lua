--[[
    Queue via Stacks: Implement a MyQueue class which  implements a queue using two stacks.
]]

local MyQueue = {}
MyQueue.__index = MyQueue

local Stack = Stack or require 'stack'

function MyQueue:new()
    self = setmetatable({
        main_stack = Stack:new(),
        backup_stack = Stack:new()
    }, MyQueue)

    return self
end

-- add
function MyQueue:enqueue(value)
    self.main_stack:push(value)
end

-- remove
function MyQueue:dequeue(value)
    if self.main_stack:count() == 1
    then
        return self.main_stack:pop()
    end

    if self.main_stack:count() == 0
    then
        return nil
    end

    for i = 1, self.main_stack:count() - 1 do
        self.backup_stack:push(self.main_stack:pop())
    end

    local result = self.main_stack:pop()
    for i = 1, self.backup_stack:count() do
        self.main_stack:push(self.backup_stack:pop())
    end

    return result
end

local my_queue = MyQueue:new()
my_queue:enqueue(1)
my_queue:enqueue(2)
my_queue:enqueue(3)

print(my_queue:dequeue()) -- 1
print(my_queue:dequeue()) -- 2
my_queue:enqueue(4)
my_queue:enqueue(5)
print(my_queue:dequeue()) -- 3
print(my_queue:dequeue()) -- 4
print(my_queue:dequeue()) -- 5
