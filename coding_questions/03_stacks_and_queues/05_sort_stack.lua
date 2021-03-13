--[[
    Sort Stack:

    Write a program to sort a stack such that the smallest items are on the top. You can
    use an additional temporary stack, but you may not copy the elements into any other data
    structure (such as an array). 
    
    The stack supports the following operations:
    push(), pop(), peek(), and is_empty().
]]

local Stack = Stack or require 'stack'

-- local dbg = require 'debugger'

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

-- if true, stack1:peek() value is greater than than stack2:peek()
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

local unsorted_stack = Stack:new({15, 12, 44, 2, 5, 10})
local sorted_stack = Stack:new()

while not unsorted_stack:is_empty() do
    if sorted_stack:is_empty()
    then
        sorted_stack:push(unsorted_stack:pop())
    end

    local compare_result = compare(unsorted_stack, sorted_stack)
    if compare_result
    then
        swap(unsorted_stack, sorted_stack)

         -- Move back to left stack to compare again.
         -- This essentially replicates a bubble sort.
        unsorted_stack:push(sorted_stack:pop())
    else
        sorted_stack:push(unsorted_stack:pop())
    end
end

print("---  TOP OF STACK ---")
sorted_stack.list:print()
print('--- BOTTOM OF STACK ---')