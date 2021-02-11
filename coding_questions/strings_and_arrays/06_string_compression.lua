--[[
    implement a method to perform basic string compression using the counts of
    repeated characters. Fo example, the string "aabcccccaaa" would become
    "a2b1c5a3". If the "compressed" string would be become smaller than the original string,
    your method should return the original string.

    Assume the string is only uppercase and lowercase letters (a-z)
]]

-- Note that strings in Lua are immutable. There isn't support for something
-- like a Java StringBuilder library, but you could probably implement one in Lua.
-- If we use mutable strings, this would be much faster, but i suppose if you're
-- aware of this situation, you understand the core concept of this exercise.
function build_compressed_string(compressed_string, char, count)
    return compressed_string .. char .. count
end

function compress(str)
    local current_char = ''
    local count = 0
    local compressed_string = ''

    for char in str:gmatch(".") do
        if (current_char ~= '') and (char ~= current_char)
        then
            compressed_string = build_compressed_string(compressed_string, current_char, count)
            count = 1 
        else
            count = count + 1
        end

        current_char = char
    end

    compressed_string = build_compressed_string(compressed_string, current_char, count)
    if #str < #compressed_string then return str end

    return compressed_string
end

function display(str, func)
    print(str .. ': ' .. func(str))
end

display('aabcccccaaa', compress) -- a2b1c5a3
display('abcdabcdabcd', compress) -- abcdabcdabcd
display('aaaaaaaaaaaa', compress) -- a12
