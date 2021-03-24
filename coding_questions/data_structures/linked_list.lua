--- A class for a doubly linked list.
-- The front of the list is the head, while the back is the tail.
-- @classmod LinkedList
-- @author KonkeyDong

local LinkedList = {}
LinkedList.__index = LinkedList
-- LinkedList.__add = function(table1, table2) -- list1 + list2
--     local new_list = LinkedList:new(table1:values())
--     for _, v in ipairs(table2:values()) do
--         new_list:add(v)
--     end

--     return new_list
-- end

local seq = require "pl.seq"
local List = require "pl.List"
-- local dbg = require 'debugger'

--- Constructor.
-- @param values A table of values (numeric or string).
-- @return instance of the object.
function LinkedList:new(values)
    self = setmetatable({ count = 0 }, LinkedList)

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            self:add(value)
        end
    end

    return self
end

--- Locate a value in a linked list object.
-- @param val A number or a string
-- @return The node with the found value or false if no value is found.
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

--- Remove all matched nodes in the linked list.
-- @param val The value to remove.
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
                self:remove_node(node)
            end
        else
            pointer = pointer.next
        end
    end
end

--- Add a value to the tail (end) of the linked list.
-- @param val The value to add to the end of the linked list.
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

-- quick and dirty. only add if we have 2 or more nodes in the list.
function LinkedList:add_by_node(node)
    if self.count > 1
    then
        self.tail.next = node

        -- calculate length
        local count = 0
        local pointer = self.head
        while pointer.next do
            count = count + 1
            pointer = pointer.next
        end

        self.tail = pointer
        self.count = count + 1

        return true
    else
        return false
    end
end

function LinkedList:link_end_to_node(node)
    self.tail.next = node
end

--- Alias for :add().
-- @param val The value to add to the end of the linked list.
function LinkedList:insert_at_end(val)
    self:add(val)
end

--- Insert a value at a specific position in the linked list.
-- If position is greater than the internal count or internal count is less than and equal to 1,
-- then add the data to the end of the list. If position is smaller than and equal to 1,
-- add to the front of the list.
-- @param val The value to add
-- @param position The position in the list to create the node. The head node is position 1.
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

--- Insert value at the front of the linked list.
-- Alias for :insert(x, 1)
-- @param val The value to add to the front of the list.
function LinkedList:insert_at_front(val)
    if self.count == 0
    then
        -- dbg()
        self:add(val)
        return
    end

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

--- Remove the node from the tail of the linked list.
-- Automatically relinks nodes.
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

--- Remove the node from the head of the linked list. 
-- Automatically relinks nodes.
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

--- Remove node from specified position. 
-- If position less than and equal to 1, remove from the front.
-- If position is greater than the internal count, remove from the end of the list.
-- @param position The node at the given position with the head node being position 1.
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

    self:remove_node(pointer)
end

--- Remove the given node from the linked list.
-- @param node The node to remove.
function LinkedList:remove_node(node)
    node.prev.next = node.next
    node.next.prev = node.prev
    node = nil

    self:_decrement_count()
end

--- Print the linked list from head to tail.
function LinkedList:print()
    local pointer = self.head
    while pointer do
        print(pointer.value)
        pointer = pointer.next
    end
end

--- Return an array preserving the order of the linked list.
-- @return An array (table) representing the linked list in order of traversal.
function LinkedList:values()
    local pointer = self.head
    local results = {}

    while pointer do
        table.insert( results, pointer.value )
        pointer = pointer.next
    end

    return results
end

--- Add linked lists.
-- @return A copy of the contents of the linked lists.
LinkedList.__add = function(table1, table2) -- list1 + list2
    local new_list = LinkedList:new(table1:values())
    for _, v in ipairs(table2:values()) do
        new_list:add(v)
    end

    return new_list
end

--- Create an iterator to traverse the linked list
-- @return An iterator that traverses the value returned from :values().
function LinkedList:iter()
    return List.new(self:values()):iter()
end

function LinkedList:_increment_count()
    self.count = self.count + 1
end

function LinkedList:_decrement_count()
    self.count = self.count - 1
end

return LinkedList
