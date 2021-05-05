--[[
    Parens

    Implement an algorithm to print all valid (e.g., properly opened and closed)
    combinations of n pairs of parentheses.

    Example:
    Input: 3
    Output: ((())), (()()), (())(), ()(()), ()()()

    Input: 2
    Output: (()), ()()

    Input: 1
    Output: ()
]]

-- solution 1: recursive with hash table (slow)
function parens(remaining)
    local set = {}
    if remaining == 0 then
        set[""] = true
    else
        local prev_set = parens(remaining - 1)

        for str, _ in pairs(prev_set) do
            for i = 1, #str do
                local char = str:sub(i, i)
                if char == '(' then
                    local s = insert_insider(str, i)

                    set[s] = true
                end
            end

            set["()" .. str] = true
        end
    end
    
    return set
end

function insert_insider(str, left_index)
    local left = str:sub(1, left_index) -- since arrays start at 1, the left_index here should not be offset by +1...
    local right = str:sub(left_index + 1, #str) -- but it should be offset down here...

    return left .. "()" .. right
end

-- solution 2: build up the string (avoids hash collisions) (faster, no duplicates)
function add_paren(list, left_rem, right_rem, str, index)
    if left_rem < 0 or right_rem < left_rem then
        return -- invalid state; return
    end

    -- out of left and right parentheses; join the string and add it to the list (as a key).
    if left_rem == 0 and right_rem == 0 then
        list[table.concat( str, "" )] = true
    else
        str[index] = '(' -- add left and recurse
        add_paren(list, left_rem - 1, right_rem, str, index + 1)

        str[index] = ')' -- add right and recurse
        add_paren(list, left_rem, right_rem - 1, str, index + 1)
    end
end

function parens2(count)
    local str = {}
    local list = {}
    add_paren(list, count, count, str, 1) -- remember that array indexes start at 1 in Lua

    return list
end

function display(starting_parens, func)
    local set = func(starting_parens)

    for k, _ in pairs(set) do
        io.write(k .. " ")
    end
    print()
end

display(3, parens)
display(3, parens2)
