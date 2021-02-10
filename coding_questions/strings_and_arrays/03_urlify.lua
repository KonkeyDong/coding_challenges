-- write a method to replace all spaces INSIDE a string with "%20".
-- Remove trailing spaces

require 'pl.stringx'.import()
function urlify(str)
    str = str:rstrip()
    return str:replace(' ', '%20')
end

function display(str)
    print(str .. ': ' .. urlify(str))
end

display('hello there') -- hello%20there
display('okie dokie   ') -- okie%20dokie
display('Mr John Smith') -- Mr%20John%20Smith
