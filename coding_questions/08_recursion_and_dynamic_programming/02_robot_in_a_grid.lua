--[[
    Robot in a Grid

    Imagine a robot sitting on the upper left corner of a grid with r rows and c columns.
    The robot can only move in two directions, right and down, but certain cells are "off limits"
    such that the robot cannot step on them. Design an algorithm to find a path for the robot
    from the top left to the bottom right.
]]

-- Using the Binomial Coefficient
function robot_grid(n)
    local paths = 1
    for i = 0, n - 1 do
        paths = paths * (2 * n - i)
        paths = paths / (i  + 1)
    end

    return math.floor(paths)
end

function display(n, func)
    print("The grid of size [" .. n .. " X " .. n .. "] has " .. tostring(func(n)) .. " ways to reach the bottom right.")
end

display(20, robot_grid)
