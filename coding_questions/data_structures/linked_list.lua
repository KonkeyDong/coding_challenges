LinkedList = {}

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

function LinkedList:find(val)
    if self.count == 0
    then
        return false
    end

    local pointer = self.head
    while pointer do
        if pointer.value == val
        then
            return pointer
        end

        pointer = pointer.next
    end

    return false
end

function LinkedList:remove_all_instances(val)
    local pointer = self.head
    for i = 1, self.count do
        if pointer.value == val
        then
            if pointer.prev == nil 
            then 
                pointer = pointer.next
                self:remove_from_front()
            elseif pointer.next == nil
            then
                self:remove_from_back()
            else
                local node = pointer
                pointer = pointer.next
                self:_remove_node(node)
            end
        else
            pointer = pointer.next
        end
    end
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

    self:_increment_count()
end

-- alias for self:add(val)
function LinkedList:insert_at_end(val)
    self:add(val)
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
        self:insert_at_front(val)
        return
    end

    self:_insert_at_position(val, position)
end

-- private function to better self-document
function LinkedList:_insert_at_position(val, position)
    local pointer = self.head
    for i = 1, position - 1 do
        pointer = pointer.next
    end

    local node = { value = val, next = pointer.next, prev = pointer}
    pointer.next.prev = node
    pointer.next = node

    self:_increment_count()
end

-- alias for self:insert(1, x)
function LinkedList:insert_at_front(val)
    local empty = nil
    local newHead = { value = val, next = self.head, prev = empty }

    self.head.prev = newHead
    self.head = newHead

    self:_increment_count()
end

function LinkedList:_check_if_one_or_fewer_items()  
    if self.count == 0
    then
        return true
    end
    
    if self.count == 1
    then
        self.head = nil
        self.tail = nil
        self.count = 0
        return true
    end

    return false
end

function LinkedList:remove_from_back()
    if self:_check_if_one_or_fewer_items()
    then
        return
    end

    local empty = nil
    local pointer = self.tail

    self.tail.prev.next = empty
    self.tail = self.tail.prev
    pointer = nil -- delete node

    self:_decrement_count()
end

function LinkedList:remove_from_front()
    if self:_check_if_one_or_fewer_items()
    then
        return
    end

    local empty = nil
    local pointer = self.head

    self.head.next.prev = empty
    self.head = self.head.next
    pointer = nil -- delete node

    self:_decrement_count()
end

-- position will start at 1 to fit with the style of arrays in Lua starting at 1
function LinkedList:remove_at(position)
    if position <= 1
    then
        self:remove_from_front()
        return
    end

    if position >= self.count
    then
        self:remove_from_back()
        return
    end

    self:_remove_at_position(position)
end

-- private function to better self-document
function LinkedList:_remove_at_position(position)
    local pointer = self.head
    for i = 1, position - 1 do
        pointer = pointer.next
    end

    self:_remove_node(pointer)
end

function LinkedList:_remove_node(node)
    node.prev.next = node.next
    node.next.prev = node.prev
    node = nil

    self:_decrement_count()
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

function LinkedList:_increment_count()
    self.count = self.count + 1
end

function LinkedList:_decrement_count()
    self.count = self.count - 1
end

return LinkedList
