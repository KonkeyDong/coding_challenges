-- Given two strings, check if one is a permutation of another

-- attempt 1: bit field and check if equal to zero
function permutation(str1, str2)
    if #str1 ~= #str2 then return false end

    str1 = string.lower( str1 )
    str2 = string.lower( str2 )
    local bit = 0
     
    -- lowercase ascii code range: 97 (a) to 122 (z)
    for char in str1:gmatch(".") do
        local code = string.byte( char ) - 97
        bit = bit | (1 << code) -- set
    end

    for char in str2:gmatch(".") do
        local code = string.byte( char ) - 97
        bit = bit & ~(1 << code) -- clear
    end

    -- print("bit: " .. bit)
    return bit == 0
end

function display(str1, str2, func)
    print(str1 .. " | " .. str2 .. ": " .. tostring(func(str1, str2)))
end

print("permutation()")
display("abc", "ab", permutation) -- false
display("abc", "cba", permutation) -- true
display("abcdef", "fdcabe", permutation) -- true


-- solution 2: sort the strings and check if they are equal to eachother. (slower, but cleaner)
local pretty = require "pl.pretty"
function permutation_sort(str1, str2)
    if #str1 ~= #str2 then return false end

    str1 = string.lower( str1 )
    str2 = string.lower( str2 )

    return sort_string(str1) == sort_string(str2)
end

function sort_string(str)
    local characters = {}
    for char in str:gmatch(".") do
        table.insert( characters, char )
    end

    -- pretty.dump(characters)
    table.sort(characters)
    return table.concat( characters, "" )
end

print("\npermutation_sort()")
display("abc", "ab", permutation_sort) -- false
display("abc", "cba", permutation_sort) -- true
display("abcdef", "fdcabe", permutation_sort) -- true