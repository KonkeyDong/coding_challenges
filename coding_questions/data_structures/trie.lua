--- A class for a Trie data structure
-- @classmod Trie
-- @author KonkeyDong

local Trie = {}
Trie.__index = Trie

local seq = require "pl.seq"
-- local dbg = require 'debugger'

--- Constructor.
-- @param values An array of strings.
-- @return Instance of the object.
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

--- Add a new string to the Trie
-- @param str A string to add to the Trie.
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

--- Find if a string is in a Trie.
-- Sets the internal 'partial_find' variable while searching for the string.
-- @param str The string to locate in the Trie. See the return. If false, the 'partial_find' variable will contain the the first characters found in the passed-in string.
-- @return The string found. If the string wasn't found, returns false.
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

--- Get an array of partial matchings.
-- @param prefix A prefix containing the first few characters found. If nil (no parameter passed), uses the internal 'partial_find' variable.
-- @return An array of strings that have a matching prefix. If no prefix can determine partial matches, returns false.
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

--- Reset the internal Trie data structure and the 'partial_find' variable.
function Trie:clear()
    self.root = {}
    self.partial_find = ''
end

function Trie:_last_character(str)
    return str:sub(-1)
end

return Trie