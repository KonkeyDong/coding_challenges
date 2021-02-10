-- given a string, write a function to check if it is a permutation of a palindrome.
-- A palindrome is a word that is the same forwards as it is backwards.
-- A permutation is a rearrangement of letters.
-- The palindrome does not need to be limited to just dictionary words.

-- Ex: "taco cat" -> true (ex: "tact coa", "atco cta", etc.)

require 'pl.stringx'.import()
function palindrome(str)
    str = str:replace(' ', ''):lower()

    -- ascii range: 97 (a) to 122 (z)
    local bit = 0
    for char in str:gmatch('.') do
        local code = char:byte() - 97
        bit = bit ~ (1 << code)
    end

    -- suppose you had the string 'abcba', after looping, the binary would look like this:
    -- 0100
    -- if you bitwise-and the number and one less than the number, (ex: 4 & (4 - 1)),
    -- you would get: 0100 & 0011 = 0000 = 0, which means you have a palindrome!
    -- this works if the number is a power of two because only one bit is set
    bit = bit & bit - 1
    if bit <= 1 then return true end

    return false
end

function display(str)
    print(str .. ': ' .. tostring(palindrome(str)))
end

display('taco cat') -- true
display('abba') -- true
display('abab') -- true 
display('racecar') -- true
display('abcxcba') -- true
display('abcd') -- false
