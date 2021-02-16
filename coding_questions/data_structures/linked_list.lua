LinkedList = {}

-- TODO: add remove logic

-- local dbg =  require "debugger"
local seq = require "pl.seq"

function LinkedList:new(values)
    local new_object = {
        count = 0
    }
    self.__index = self
     setmetatable(new_object, self)

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            new_object:add(value)
        end
    end

    return new_object
end

-- default add to tail
function LinkedList:add(val)
    -- Setting the value of a key/value pair directly to nil will just delete the key.
    -- To get around this, we set a variable to nil and use that in place.
    local empty = nil 
    if self.count == 0
    then
        self.head = {value = val, next = empty, prev = empty}
        self.tail = self.head
    else
        if self.count == 1 -- special case with double-linked-lists
        then
            self.head.next = {value = val, next = empty, prev = self.head}
        end

        self.tail.next = {value = val, next = empty, prev = self.tail}
        self.tail = self.tail.next
    end

    self:increment_count()
end

-- position will start at 1 to fit with the style of arrays in Lua starting at 1
function LinkedList:insert(val, position)
    -- just add normally after tail
    if self.count <= 1 or position >= self.count
    then
        self:add(val)
        return
    end

    if position <= 1
    then
        self:insert_before_head(val)
        return
    end

    self:_insert_at_position(val, position)
end

function LinkedList:_insert_at_position(val, position)
    local pointer = self.head
    for i = 1, position - 1 do
        pointer = pointer.next
    end

    local node = { value = val, next = pointer.next, prev = pointer}
    pointer.next.prev = node
    pointer.next = node

    self:increment_count()
end

-- alias for self:insert(1, x)
function LinkedList:insert_before_head(val)
    local empty = nil
    local newHead = { value = val, next = self.head, prev = empty }

    self.head.prev = newHead
    self.head = newHead

    self:increment_count()
end

function LinkedList:print()
    local pointer = self.head
    while pointer do
        print(pointer.value)
        pointer = pointer.next
    end
end

function LinkedList:values()
    local pointer = self.head
    local results = {}

    while pointer do
        table.insert( results, pointer.value )
        pointer = pointer.next
    end

    return results
end

function LinkedList:increment_count()
    self.count = self.count + 1
end

function LinkedList:decrement_count()
    self.count = self.count - 1
end

return LinkedList
