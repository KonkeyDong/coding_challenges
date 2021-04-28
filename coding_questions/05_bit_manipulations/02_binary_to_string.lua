--[[
    Binary to String

    Given a real number between 0 and 1 (e.g., 0.72) that is passed in as a double,
    pass the binary representation. If the number cannot be represented accurately in
    binary with at most 32 characters, print "ERROR."
]]

local BM = BitManipulations or require 'bit_manipulations'

-- decimal = double type number
function binary_to_string(decimal)
    local fraction = math.fmod(decimal, 1)

    -- print(whole_number)
    local s = ""
    while fraction ~= 0 do
        if #s > 32 then
            print("ERROR")
            return
        end

        local remainder = fraction * 2
        if remainder >= 1 then
            s = s .. "1"
            fraction = remainder - 1
        else
            s = s .. "0"
            fraction = remainder
        end
    end

    print(s)
end

binary_to_string(0.125)
binary_to_string(0.75)
binary_to_string(0.72) -- binary repeats
