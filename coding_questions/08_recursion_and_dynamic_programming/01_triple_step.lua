--[[
    Triple Step

    A child is running up a staircase with n steps and can hop either 1, 2, or 3 steps at a time.
    Implement a method to count how many possible ways the child can run up the stairs.
]]

local memo = {1, 2, 4}

function triple_step(n)
    if n < 1 then
        return 0
    end
    
    if not memo[n] then
        memo[n] = triple_step(n - 1) + triple_step(n - 2) + triple_step(n - 3)
    end

    return memo[n]
end

function display(n, func)
    print("The number [" .. n .. "] has " .. tostring(func(n)) .. " ways to reach that step.")
end

display(4, triple_step)
display(5, triple_step)
display(100, triple_step)
