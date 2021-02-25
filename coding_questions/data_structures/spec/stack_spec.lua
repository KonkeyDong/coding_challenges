local path = require 'pl.path'.abspath('..')
package.path = package.path .. ';' .. path .. '/?.lua'
local Stack = Stack or require 'stack'

-- local dbg = require 'debugger'

require "busted"
describe('Stack', function()
    io.write('\nStack tests: ')
    describe(':new()', function()
        it('should create an empty stack', function()
            local stack = Stack:new()

            assert.is_true(stack:is_empty(), true)
        end)

        it('should create a stack with data', function()
            local stack = Stack:new({1, 2, 3})

            assert.is_false(stack:is_empty(), false)
            assert.is_equal(stack:count(), 3)
            assert.are.same(stack:values(), {3, 2, 1})
        end)
    end)

    describe(':push()', function()
        it('should push a value to the front of the stack', function()
            local stack = Stack:new()
            stack:push(1)
            stack:push(2)
            stack:push(3)

            assert.is_equal(stack:count(), 3)
            assert.are.same(stack:values(), {3, 2, 1})
        end)
    end)

    describe(':pop()', function()
        it('should return nil if the stack is empty', function()
            local stack = Stack:new()
            
            assert.is_equal(stack:count(), 0)
            assert.is_nil(stack:pop())
            assert.is_equal(stack:count(), 0)
        end)

        it('should return the last item pushed to the list', function()
            local stack = Stack:new({1, 2, 3})

            assert.is_equal(stack:count(), 3)
            assert.is_equal(stack:pop(), 3)
            assert.is_equal(stack:count(), 2)

            assert.is_equal(stack:pop(), 2)
            assert.is_equal(stack:count(), 1)

            assert.is_equal(stack:pop(), 1)
            assert.is_equal(stack:count(), 0)

            assert.is_equal(stack:pop(), nil)
            assert.is_equal(stack:count(), 0)
        end)
    end)

    describe(':peek()', function()
        it('should return nil on an empty list', function()
            local stack = Stack:new()

            assert.is_nil(stack:peek())
        end)

        it('should return the last item pushed on the stack', function()
            local stack = Stack:new({1, 2, 3})

            assert.is_equal(stack:count(), 3)
            assert.is_equal(stack:peek(), 3)
            assert.is_equal(stack:count(), 3)
        end)
    end)

    describe(':is_empty()', function()
        it('should return true if the stack is empty', function()
            local stack = Stack:new()

            assert.is_true(stack:is_empty())
        end)

        it('should return false if the stack is not empty', function()
            local stack = Stack:new({1})

            assert.is_false(stack:is_empty())
        end)
    end)

    describe(':min()', function()
        it('should return nil if the stack is empty', function()
            local stack = Stack:new()

            assert.is_nil(stack:min())
        end)

        it('should return 1 if the stack is full', function()
            local stack = Stack:new({1, 2, 3})

            assert.is_equal(stack:min(), 1)
            
            stack:pop()
            assert.is_equal(stack:min(), 1)

            stack:pop()
            assert.is_equal(stack:min(), 1)

            stack:pop()
            assert.is_nil(stack:min())
        end)

        it('should return 1, 2, then 3', function()
            local stack = Stack:new({3, 2, 1})

            assert.is_equal(stack:min(), 1)
            
            stack:pop()
            assert.is_equal(stack:min(), 2)

            stack:pop()
            assert.is_equal(stack:min(), 3)

            stack:pop()
            assert.is_nil(stack:min())
        end)

        it('should return 1, then 0, and finally 1 again', function()
            local stack = Stack:new({1, 2, 3})

            assert.is_equal(stack:min(), 1)
            stack:push(0)
            assert.is_equal(stack:min(), 0)
            stack:pop()
            assert.is_equal(stack:min(), 1)
        end)
    end)
end)
