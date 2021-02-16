local path = require 'pl.path'.abspath('../data_structures')
package.path = package.path .. ';' .. path .. '/linked_list.lua'
local LinkedList = require 'data_structures.linked_list'

require "busted"
local seq = require "pl.seq"
local pretty = require "pl.pretty"


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
            checkEnds(list)
        
            check_if_linking_is_correct(list, {1})
            assert.is_equal(list.count, 1)
            assert.are.same(list:values(), {1})
        end)

        it('should add two items to list', function()
            local list = LinkedList:new({1, 2})
        
            checkEnds(list)
            check_if_linking_is_correct(list, {1, 2})
        
            assert.is_equal(list.count, 2)
            assert.are.same(list:values(), {1, 2})
        end)

        it('should handle more than two items added to the list', function()
            local list = LinkedList:new({1, 2, 3})

            checkEnds(list)
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

                    checkEnds(list)
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
end)

function checkEnds(list)
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