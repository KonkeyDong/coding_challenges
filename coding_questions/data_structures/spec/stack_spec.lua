local path = require 'pl.path'.abspath('..')
package.path = package.path .. ';' .. path .. '/?.lua'
local Stack = Stack or require 'stack'

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
end)
