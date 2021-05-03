--[[
    Magic Index

    A magic index in an array A[0...n-1] is defined to be an index such that A[i] = i.
    Given a sorted array of distinct integers, write a method to find a magic index,
    if one exists, in array A.
]]

function magic_index(array)
    local result = false    
    local mid = round(#array / 2)
    local lower = 0
    local higher = #array

    while lower < higher do
        if mid == array[mid] then
            return true
        end

        if n > mid then
            lower = mid + 1
        else
            higher = mid - 1
        end

        mid = round(lower + (higher - lower) / 2)
    end


    return result
end

-- follow up: what if the numbers are not distinct?
-- The brute force solution will work again here: O(n) time. 
-- But we can do slightly better since the numbers are still sorted.
function magic_index2(array)
    return magic_index2_helper(array, 0, #array)
end

function magic_index2_helper(array, start, last)
    if last < start then
        return -1
    end

    local mid_index = round((start + last) / 2)
    local mid_value = array[mid_index]

    if mid_value == mid_index then
        return mid_index
    end

    -- search left
    local left_index = math.min(mid_index - 1, mid_value)
    local left = magic_index2_helper(array, start, left_index)
    if left >= 0 then
        return left
    end

    -- serach right
    local right_index = math.max(mid_index + 1, mid_value)
    local right = magic_index2_helper(array, right_index, last)

    return right
end

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n) 
end

function display(array, func)
    print("magic index found: " .. tostring(func(array)))
end

-- display({1, 2, 3, 4, 5}, magic_index)
-- display({1, 2, 3, 4, 6}, magic_index)

display({-10, -5, 2, 2, 2, 3, 4, 8, 9, 12, 13}, magic_index2)