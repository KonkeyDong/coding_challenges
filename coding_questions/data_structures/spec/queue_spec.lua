local path = require 'pl.path'.abspath('..')
package.path = package.path .. ';' .. path .. '/?.lua'
local Queue = Queue or require 'queue'

describe('Queue', function()
    io.write('\nQueue tests: ')
    describe(':new()', function()
        it('should create an empty queue', function()
            local queue = Queue:new()

            assert.is_true(queue:is_empty())
        end)

        it('should create a queue', function()
            local queue = Queue:new({1, 2, 3})

            assert.is_false(queue:is_empty())
            assert.is_equal(queue:count(), 3)
            assert.are.same(queue:values(), {1, 2, 3})
        end)
    end)

    describe(':add()', function()
        it('should add an item to the back of a queue', function()
            local queue = Queue:new({1, 2, 3})

            assert.is_equal(queue:count(), 3)
            assert.are.same(queue:values(), {1, 2, 3})

            queue:add(4)
            assert.is_equal(queue:count(), 4)
            assert.are.same(queue:values(), {1, 2, 3, 4})
        end)
    end)

    describe(':remove()', function()
        it('should return nil if the queue is empty', function()
            local queue = Queue:new()

            assert.is_equal(queue:count(), 0)
            assert.is_nil(queue:remove())
            assert.is_equal(queue:count(), 0)
        end)

        it('should return the first item in the list', function()
            local queue = Queue:new({1, 2, 3})

            assert.is_equal(queue:count(), 3)
            assert.is_equal(queue:remove(), 1)
            assert.is_equal(queue:count(), 2)

            assert.is_equal(queue:remove(), 2)
            assert.is_equal(queue:count(), 1)

            assert.is_equal(queue:remove(), 3)
            assert.is_equal(queue:count(), 0)

            assert.is_equal(queue:remove(), nil)
            assert.is_equal(queue:count(), 0)
        end)
    end)

    describe(':peek()', function()
        it('should return nil if the queue is empty', function()
            local queue = Queue:new()

            assert.is_nil(queue:peek())
        end)

        it('should return the first item in the queue', function()
            local queue = Queue:new({1, 2, 3})

            assert.is_equal(queue:count(), 3)
            assert.is_equal(queue:peek(), 1)
            assert.is_equal(queue:count(), 3)
        end)
    end)

    describe(':is_empty()', function()
        it('should return false', function()
            local queue = Queue:new()

            assert.is_true(queue:is_empty())
        end)

        it('should return false', function()
            local queue = Queue:new({1, 2, 3})

            assert.is_false(queue:is_empty())
        end)
    end)
end)