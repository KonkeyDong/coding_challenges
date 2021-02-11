--[[
    There are three types of edits that can be performed on strings:
    1) insert a character
    2) remove a character
    3) replace a character
    Given two strings, write a function to check if they are one edit (or zero edits) away.

    Example:
        pale, ple -> true
        pales, pale -> true
        pale, bale -> true
        pale, bake -> false
--]]

-- Solution 1: hash map (slightly inefficient with the loop over the table at the end)
require "pl.stringx".import()
function one_away(str1, str2)
    str1 = str1:lower()
    str2 = str2:lower()

    local cache = {}
    for char in str1:gmatch(".") do
        local value = cache[char]

        if value
        then
            cache[char] = value + 1
        else
            cache[char] = 1 
        end
    end

    for char in str2:gmatch(".") do
        local value = cache[char]
        
        if value
        then
            cache[char] = value - 1
        else
            cache[char] = nil -- delete
        end
    end

    local total = 0
    for key, value in pairs(cache) do
        total = total + value
    end

    if total <= 1 
    then 
        return true 
    else 
        return false 
    end
end

function display(str1, str2, func)
    print(str1 .. " | " .. str2 .. ": " .. tostring(func(str1, str2)))
end

display("pale", "ple", one_away) -- true
display("pales", "pale", one_away) -- true
display("pale", "bale", one_away) -- true
display("pale", "bake", one_away) -- true
display("bbbd", "bbb", one_away) -- true

-- Solution 2: use indexes and loop over both strings just once (no hash table implementation; faster)
function one_away2(str1, str2)
    str1 = str1:lower()
    str2 = str2:lower()

    local short = get_shorter_string(str1, str2)
    local long  = get_longer_string(str1, str2)

    local index1, index2 = 1, 1 -- shorter, longer (respectively)
    local found_difference = false

    while index2 < #short and index1 < #long do
        if char_at_index(short, index2) ~= char_at_index(long, index1) -- found the first difference in the string
        then
            if found_difference then return false end -- if second difference, we know the strings aren't "one away"
            found_difference = true

            if #short == #long 
            then 
                index1 = index1 + 1 
            end

        else
            index1 = index1 + 1 -- increment shorter string index
        end

        index2 = index2 + 1 -- always increment longer string index
    end

    return true
end

local function _smaller_string(str1, str2)
    if #str1 < #str2 
    then 
        return str1 
    else 
        return str2 
    end
end

function get_shorter_string(str1, str2)
    return _get_smaller_string(str1, str2)
end

function get_longer_string(str1, str2)
    return _get_smaller_string(str2, str1) -- note the variable swap
end

function char_at_index(str, index)
    return string.sub(str, index, index)
end

print("\n--------------")
display("pale", "ple",   one_away2) -- true
display("pales", "pale", one_away2) -- true
display("pale", "bale",  one_away2) -- true
display("pale", "bake",  one_away2) -- true
display("bbbd", "bbb",   one_away2) -- true