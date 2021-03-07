--[[
    Sort Stack:

    Write a program to sort a stack such that the smallest items are on the top. You can
    use an additional temporary stack, but you may not copy the elements into any other data
    structure (such as an array). 
    
    The stack supports the following operations:
    push(), pop(), peek(), and is_empty().
]]

local path = require 'pl.path'.abspath('../data_structures')
package.path = package.path .. ';' .. path .. '/?.lua'
local Stack = Stack or require 'stack'

local dbg = require 'debugger'


function swap(stack1, stack2)
    local temp = stack1:pop()
    stack1:push(stack2:pop())
    stack2:push(temp)
end

function both_not_empty(stack1, stack2)
    if not stack1:is_empty() and not stack2:is_empty()
    then
        return true
    else
        return false
    end
end

-- if true, stack1:peek() value is smaller than stack2:peek()
function compare(stack1, stack2)
    if both_not_empty(stack1, stack2)
    then

        if stack1:peek() > stack2:peek()
        then
            return true
        else
            return false
        end
    end

    return nil
end

local main_stack = Stack:new({2, 1, 3})
local temp_stack = Stack:new()

while not main_stack:is_empty() do
    if temp_stack:is_empty()
    then
        temp_stack:push(main_stack:pop())
    end

    local compare_result = compare(main_stack, temp_stack)
    if compare_result
    then
        swap(main_stack, temp_stack)
    else
        temp_stack:push(main_stack:pop())
    end
end

-- Basic sort, but can't handle special cases. Will need to investigate.
temp_stack.list:print()
dbg()
print('TEST')