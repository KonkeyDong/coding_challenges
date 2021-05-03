--[[
    Power Set

    Write a method to return all subsets of a set.
]]

WIP

local dbg = require 'debugger'

local sub_sets = {}

function power_set(set)
    if #set == 0 then
        return
    end

    table.insert(sub_sets, set)

    for i, v in ipairs(set) do
        local first = v
        set[i] = nil
        power_set(set)
        table.insert(set, first)
    end
end

power_set({1, 2, 3, 4})

dbg()
print("hi")

