local array = {"Blue", "Red", "Green", "White"}

function permutation(start, last)
    if last == start then
        print_array(array)
        return
    end

    for i = start, last do
        -- swap
        array[i], array[start] = array[start], array[i]

        permutation(start + 1, last)

        -- restore
        array[i], array[start] = array[start], array[i]
    end
end

function print_array(array)
    for _, v in ipairs(array) do
        io.write(v .. " ")
    end

    print()
end

permutation(1, #array)
