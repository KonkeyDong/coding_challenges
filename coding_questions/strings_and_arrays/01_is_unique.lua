-- Implement an algorithm to determine if a string has all unique characters.
-- Follow up: What if you cannot use an additional data structure?

-- Solution 1: hash table (uses much more storage)
function is_unique(str)
    if #str == 0 then return true end

    -- just assume lowercase. Assume ASCII over unicode.
    str = string.lower( str )
    local unique = {}
    for char in str:gmatch( "." ) do
        if unique[char] then return false end

        unique[char] = true
    end

    return true
end

function display(str, func)
    print(str .. ": " .. tostring(func(str)))
end

print("is_unique()")
display("abc", is_unique) -- true
display("", is_unique) -- true
display("aba", is_unique) -- false
display("Aba", is_unique) -- false (ignore case)
display("unique", is_unique) -- false
display("racecar", is_unique) -- false
display("badge", is_unique) -- true

-- Solution 2 (better): bit field (no additional data structure) -- 64-bits of storage
function is_unique_bit(str)
    if #str == 0 then return true end

    -- just assume lowercase. Assume ASCII over unicode.
    -- only look at ascii values between 97 (a) and 122 (z) inclusive
    str = string.lower(str)
    local bit = 0;
    for char in str:gmatch(".") do
        local code = string.byte(char) - 97

        if bit & (1 << code ) > 0 then return false end

        bit = bit | (1 << code)
    end

    return true
end

print("\nis_unique_bit()")
display("abc", is_unique_bit) -- true
display("", is_unique_bit) -- true
display("aba", is_unique_bit) -- false
display("Aba", is_unique_bit) -- false (ignore case)
display("unique", is_unique_bit) -- false
display("racecar", is_unique_bit) -- false
display("badge", is_unique_bit) -- true
