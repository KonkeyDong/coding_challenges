--[[
    Permutations without dups

    Write a method to compute all permutations of a string of unique characters.
]]

local Queue = Queue or require("queue")
local queue = Queue:new()
local dbg = require("debugger")

function permutations(start, last, array)
    if last == start then
        queue:add(array)
        return
    end
    
    for i = start, last do
        -- swap
        array[i], array[start] = array[start], array[i]
        
        permutations(start + 1, last, array)
        
        -- restore
        array[i], array[start] = array[start], array[i]
    end
end

-- Note: this isn't a string, but the premise remains the same.
local array = {"Blue", "Red", "Green", "White"}
permutations(1, #array, array)

for _, perm in ipairs(queue:values()) do
    for _, v in ipairs(perm) do 
        io.write(v .. " ")
    end

    print() -- new line
end
