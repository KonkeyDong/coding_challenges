local path = require 'pl.path'.abspath('../data_structures')
package.path = package.path .. ';' .. path .. '/linked_list.lua'
local LinkedList = require 'data_structures.linked_list'

require "busted"
local seq = require "pl.seq"
local pretty = require "pl.pretty"
-- local dbg = require "debugger"

describe("LinkedList", function()
    describe(":add()", function()
        it('should represent an empty double-linked list', function()
            local list = LinkedList:new()
            
            assert.is_nil(list.head)
            assert.is_nil(list.tail)
            assert.is_equal(list.count, 0)
        end)

        it('should add 1 item to the list', function()
            local list = LinkedList:new({1})        
            check_ends(list)
        
            check_if_linking_is_correct(list, {1})
            assert.is_equal(list.count, 1)
            assert.are.same(list:values(), {1})
        end)

        it('should add two items to list', function()
            local list = LinkedList:new({1, 2})
        
            check_ends(list)
            check_if_linking_is_correct(list, {1, 2})
        
            assert.is_equal(list.count, 2)
            assert.are.same(list:values(), {1, 2})
        end)

        it('should handle more than two items added to the list', function()
            local list = LinkedList:new({1, 2, 3})

            check_ends(list)
            check_if_linking_is_correct(list, {1, 2, 3})

            assert.is_equal(list.count, 3)
            assert.are.same(list:values(), {1, 2, 3})
        end)
    end)

    describe(':insert()', function()
        describe('first position insert (head)', function()
            it('should insert into first position if empty', function()
                local check_insert_first_position = function (position)
                    local list = LinkedList:new()
                    list:insert(1, position)

                    check_ends(list)
                    check_if_linking_is_correct(list, {1})
                    assert.is_equal(list.count, 1)
                    assert.are.same(list:values(), {1})
                end

                check_insert_first_position(1)
                check_insert_first_position(0)
                check_insert_first_position(-1) -- all negative numbers
            end)

            it('should insert into first position if pre-populated', function()
                local prepopulate_and_insert = function (position)
                    list = LinkedList:new({1, 2, 3})
                    list:insert(4, position)

                    local test_list = {4, 1, 2, 3}
                    check_if_linking_is_correct(list, test_list)
                    assert.is_equal(list.count, 4)
                    assert.are.same(list:values(), test_list)
                end

                prepopulate_and_insert(1)
                prepopulate_and_insert(0)
                prepopulate_and_insert(-1) -- all negative numbers
            end)
        end)

        it('should insert at the end if pre-populated', function()
            local prepopulate_and_insert_at_end = function(position)
                local list = LinkedList:new({1, 2})

                list:insert(17, position)
                local test_list = {1, 2, 17}
                check_if_linking_is_correct(list, test_list)
                assert.is_equal(list.count, 3)
                assert.are.same(list:values(), test_list)
            end

            prepopulate_and_insert_at_end(2)
            prepopulate_and_insert_at_end(3)
            prepopulate_and_insert_at_end(99)
        end)

        it('should insert 17 after 2 and before 3', function()
            local list = LinkedList:new({1, 2, 3})

            list:insert(17, 2)
            local test_list = {1, 2, 17, 3}
            check_if_linking_is_correct(list, test_list)
            assert.is_equal(list.count, 4)
            assert.are.same(list:values(), test_list)
        end)
    end)

    describe('removing items from the linked list |', function()
        describe(':remove_from_back()', function()
            local METHOD_NAME = 'remove_from_back'

            it('should do nothing if the list is empty', function()
                remove_from_empty_list(METHOD_NAME)
            end)

            it('should destroy the nodes if one item remains', function()
                remove_from_list_with_one_item(METHOD_NAME, {'bologna'})
            end)

            it('should remove the last node from the list', function()
                remove_from_list_with_more_than_one_item(
                    METHOD_NAME, 
                    {'bologna', 'bogus', 'garbage'}, 
                    {'bologna', 'bogus'}
                )
            end)
        end)

        describe(':remove_from_front()', function()
            local METHOD_NAME = 'remove_from_front'

            it('should do nothing if the list is empty', function()
                remove_from_empty_list(METHOD_NAME)
            end)

            it('should destroy the nodes if one item remains', function()
                remove_from_list_with_one_item(METHOD_NAME, {'bologna'})
            end)

            it('should remove the first node from the list', function()
                remove_from_list_with_more_than_one_item(
                    METHOD_NAME, 
                    {'bologna', 'bogus', 'garbage'}, 
                    {'bogus', 'garbage'}
                )
            end)
        end)

        function remove_from_empty_list(func)
            local list = LinkedList:new()

            assert.is_equal(list.count, 0)
            LinkedList[func](list)
            assert.is_equal(list.count, 0)
        end

        function remove_from_list_with_one_item(func, data)
            local list = LinkedList:new(data)

            assert.is_equal(list.count, #data)
            LinkedList[func](list)
            assert.is_equal(list.count, 0)
            assert.is_nil(list.head)
            assert.is_nil(list.tail)
        end
        
        function remove_from_list_with_more_than_one_item(func, data, result_data)
            local list = LinkedList:new(data)

            local test_list = result_data
            assert.is_equal(list.count, #data)
            LinkedList[func](list)
            check_if_linking_is_correct(list, test_list)
            assert.is_equal(list.count, #result_data)
            assert.are.same(list:values(), test_list)
        end
    end)

    describe(':remove_at()', function()
        local test_data = {1, 2, 3, 4, 5}

        it('should remove from head if position is <= 1', function()
            local result_data = {2, 3, 4, 5}

            check_position(1, test_data, result_data)
            check_position(0, test_data, result_data)
            check_position(-1, test_data, result_data)
        end)

        it('should remove from tail if position is >= count', function()
            local result_data = {1, 2, 3, 4}

            check_position(5, test_data, result_data)
            check_position(6, test_data, result_data)
        end)

        it('should remove node at specified position', function()
            check_position(2, test_data, {1, 3, 4, 5})
            check_position(3, test_data, {1, 2, 4, 5})
            check_position(4, test_data, {1, 2, 3, 5})
        end)

        function check_position(position, data, result_data)
            local list = LinkedList:new(data)

            check_ends(list)
            assert.is_equal(list.count, #data)
            list:remove_at(position)
            check_if_linking_is_correct(list, result_data)
            assert.is_equal(list.count, #result_data)
            assert.are.same(list:values(), result_data)
        end
    end)

    describe(':find()', function()
        it('should find the value and return the node', function()
            local list = LinkedList:new({1, 2, 3})
            local node = list:find(2)

            assert.is_equal(node.value, 2)
            assert.is_equal(node.prev.value, 1)
            assert.is_equal(node.next.value, 3)
        end)

        it('should return false is nothing is found', function()
            local list = LinkedList:new({1, 2, 3}) 

            assert.is_false(list:find('bologna'))
        end)

        it('should return false if the list is empty', function()
            local list = LinkedList:new()

            assert.is_false(list:find('bologna'))
        end)
    end)
end)

function check_ends(list)
    assert.is_nil(list.head.prev)
    assert.is_nil(list.tail.next)
end

function check_if_linking_is_correct(list, values)
    check_moving_forward(list, values)
    check_moving_backward(list, reverse_array(values))
end

-- check if links are intact
function check_moving_forward(list, values)
    -- pretty.dump(values)
    local pointer = list.head
    for value in seq.list(values) do
        assert.is_equal(pointer.value, value)
        pointer = pointer.next
    end

    assert.is_nil(pointer)
end

-- check if links are intact
function check_moving_backward(list, values)
    local pointer = list.tail
    for value in seq.list(values) do
        assert.is_equal(pointer.value, value)
        pointer = pointer.prev
    end

    assert.is_nil(pointer)
end

function reverse_array(array)
    local results = {}
    for i = #array, 1, -1 do
        table.insert( results, array[i] )
    end

    return results
end