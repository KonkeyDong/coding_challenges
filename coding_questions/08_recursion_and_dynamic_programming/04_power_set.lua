--[[
    Power Set

    Write a method to return all subsets of a set.
]]

-- NOTE: This kind of works, but I think Lua is showing some problems
--       whenever it comes to arrays of arryas with no data in sub arrays.
--       I'll have to replicate this using a different language. Probably python.

function power_set(set)
    local all_subsets = {}
    local max = 1 << #set

    for k = 1, max do
        local subset = convert_int_to_set(k, set)
        table.insert(all_subsets, subset)
    end

    return all_subsets
end

function convert_int_to_set(x, set)
    local subset = {}
    local index = 0

    local k = x
    while k > 0 do
        if (k & 1) == 1 then
            table.insert(subset, set[index])
        end

        index = index + 1

        k = k >> 1
    end

    return subset
end

local x = power_set({1, 2, 3, 4})

print("listing sets")
for _, subset in ipairs(x) do
    for _, v in ipairs(subset) do
        io.write(v .. " ")
    end
    print()
end
