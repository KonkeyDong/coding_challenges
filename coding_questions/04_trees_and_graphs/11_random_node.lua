--[[
    Random Node:

    You are implementing a binary tree class from scratch which, in addition to 
    insert(), find(), and delete(), has a method get_random_node() which returns a 
    random node from the tree. All nodes should be equally likely to be chosen. Design
    and implement an algorithm for get_random_node(), and explain how you would implement
    the rest of the methods.
]]

-- The simplest way I can think of choosing a random node is to have an internal array/hash in the
-- binary tree class where each element points to a node. Simply call random() in some way and return
-- whatever the array is pointing. But that seems to simple and the inteviewer might want something else.

-- We could also try simple probabilities: 1/3 pick node, 1/3 go left, and 1/3 go right, but that wouldn't
-- have equal probabilities. The root will be picked 1/3 of the time, but that would mean that each node downwards
-- would have a (1/3) ^ (depth) chance of getting picked. Therefore, the chance of getting picked should be (1/n)
-- where n is the number of nodes in the tree. Also, the chances of going left/right are not 50/50 since one
-- side of the tree might have more nodes than the other. So, you'd weight the chances in favor of the side of the
-- tree that have more nodes.

local RandomTree = {}
RandomTree.__index = RandomTree

local dbg = require 'debugger'

EMPTY = nil

-- this solution kinda works. It basically just picks a number and then looks for it.
function RandomTree:new()
    self = setmetatable({ 
        size = 0, 
    }, RandomTree)

    RandomTree._seed_random(self)

    return self
end

function RandomTree:insert(data)
    self:_insert_helper(data, self.root)
    self.size = self.size + 1
end

function RandomTree:_insert_helper(data, node)
    -- dbg()
    if not node
    then
        node = { value = data, size = self.size, left = EMPTY, right = EMPTY }

        if self.size == 0
        then
            self.root = node
        end

        return node
    end

    if data <= node.value
    then
        if not node.left
        then
            node.left = RandomTree:_insert_helper(data, node.left)
        else
            RandomTree:_insert_helper(data, node.left)
        end
    else
        if not node.right
        then
            node.right = RandomTree:_insert_helper(data, node.right)
        else
            RandomTree:_insert_helper(data, node.right)
        end
    end
end

function RandomTree:find(data)
    return self:_find_helper(data, self.root)
end

function RandomTree:_find_helper(data, node)
    if not node
    then
        return nil
    end

    if data == node.value
    then
        return node
    elseif data <= node.value
    then
        return self:_find_helper(data, node.left)
    else
        return self:_find_helper(data, node.right)
    end
end

function RandomTree:get_random_node()
    local left_size = self.size 
    
    local index = math.random(1, left_size)
    io.write('random number: ' .. index .. ' | ')
    return self:find(index)
end

-- lua's random function is odd. You have to throw away the first
-- five random calls in order to get random data as the first five
-- can be the same between seeds.
function RandomTree:_seed_random()
    math.randomseed(os.time())

    for i = 1, 5 do
        math.random()
    end
end

local tree = RandomTree:new()
tree:insert(5)
tree:insert(3)
tree:insert(7)
tree:insert(1)
tree:insert(2)
tree:insert(6)
tree:insert(8)

-- dbg()

for i = 1, tree.size do
    local node = tree:get_random_node()
    -- dbg()
    local result = node and node.value or nil 
    print('i = ' .. i .. ' | random node is: ' .. tostring(result))
end