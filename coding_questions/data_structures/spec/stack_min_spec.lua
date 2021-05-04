local path = require 'pl.path'.abspath('..')
package.path = package.path .. ';' .. path .. '/?.lua'
local StackMin = StackMin or require 'stack_min'

require "busted"
describe('StackMin', function()
    io.write('\nStackMin tests: ')
    describe(':min()', function()
        it('should return nil if the stack is empty', function()
            local stack = StackMin:new()

            assert.is_nil(stack:min())
        end)

        it('should return 1 if the stack is full', function()
            local stack = StackMin:new({1, 2, 3})

            assert.is_equal(stack:min(), 1)
            
            stack:pop()
            assert.is_equal(stack:min(), 1)

            stack:pop()
            assert.is_equal(stack:min(), 1)

            stack:pop()
            assert.is_nil(stack:min())
        end)

        it('should return 1, 2, then 3', function()
            local stack = StackMin:new({3, 2, 1})

            assert.is_equal(stack:min(), 1)
            
            stack:pop()
            assert.is_equal(stack:min(), 2)

            stack:pop()
            assert.is_equal(stack:min(), 3)

            stack:pop()
            assert.is_nil(stack:min())
        end)

        it('should return 1, then 0, and finally 1 again', function()
            local stack = StackMin:new({1, 2, 3})

            assert.is_equal(stack:min(), 1)
            stack:push(0)
            assert.is_equal(stack:min(), 0)
            stack:pop()
            assert.is_equal(stack:min(), 1)
        end)
    end)
end)
