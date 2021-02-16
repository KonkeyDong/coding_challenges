-- Rather ugly relative require statements, but i suppose if
-- we had a main file, you would only have to set the path once.
local path = require 'pl.path'.abspath('../data_structures')
package.path = package.path .. ';' .. path .. '/linked_list.lua'
local list = require 'data_structures.linked_list':new()

-- list:add(1)
-- list:add(2)
-- list:add(3)
-- list:add(4)
-- list:add(5)
-- list:print()

function test(a, ...)
    local b = {...}
    b = b[1] or '?'

    print('a = ' .. a)
    print('b = ' .. b)
end

test(1)
test(1, 2)
