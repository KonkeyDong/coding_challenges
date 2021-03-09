local Trie = {}
Trie.__index = Trie

local seq = require "pl.seq"
-- local dbg = require 'debugger'

function Trie:new(values)
    self = setmetatable({
        root = {},
        partial_find = ''
    }, Trie)

    if values ~= nil and #values > 0
    then
        for value in seq.list(values) do
            self:add(value)
        end
    end

    return self
end

function Trie:add(str)
    local pointer = self.root
    for char in str:sub(1, -2):gmatch( "." ) do
        if not pointer[char]
        then
            pointer[char] = {}
        end

        pointer = pointer[char]
    end

    pointer[self:_last_character(str)] = str
end

-- if nothing is found, returns false.
-- Use get_partial_matchings() to find potential matches
function Trie:find(str)
    self.partial_find = '' -- reset
    local pointer = self.root

    for char in str:gmatch( "." ) do
        if not pointer[char]
        then
            return false;
        end

        self.partial_find = self.partial_find .. char
        pointer = pointer[char]
    end

    return pointer[self:_last_character(str)]
end

function Trie:get_partial_matchings(prefix)
    if not prefix
    then 
        prefix = self.partial_find
    end

    local pointer = self.root
    for char in prefix:gmatch( "." ) do
        if not pointer[char]
        then
            return false
        end
        
        pointer = pointer[char]
    end

    local list = {}
    self:_recurse_over_listings(pointer, list)
    table.sort(list)

    return list
end

function Trie:_recurse_over_listings(pointer, list)
    if type(pointer) == 'table'
    then
        for char in pairs(pointer) do
            -- if the character is a single character string, we found a key.
            -- recursively call the function again but using the next character
            if type(char == 'string' and #char == 1)
            then
                self:_recurse_over_listings(pointer[char], list)
            end
        end
    else
        -- we found data. push to an array and search again.
        table.insert( list, pointer )
        return
    end
end

function Trie:clear()
    self.root = {}
    self.partial_find = ''
end

function Trie:_last_character(str)
    return str:sub(-1)
end

return Trie