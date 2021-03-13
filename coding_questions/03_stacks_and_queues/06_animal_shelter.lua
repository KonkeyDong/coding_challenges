--[[
    Animal Shelter:

    An animal shelter, which holds only dogs and cats, operates on a strictly "first in, first out"
    basis. People must adopt either the "oldest" (based on arrival time) of all animals at the shelter,
    or they can select whether they would prefer a dog or a cat (and will receive the oldest animal 
    of that type). They cannot select which specific animal they would like. Create the data structure
    to maintain this system and implement operations such as:

    enqueue(), dequeue_any(), dequeue_dog(), and dequeue_cat().

    You may use the built-in LinkedList data structure.

    Programmer's note: just use D for dog and C for cat to keep this simplicity.
]]

local AnimalQueue = Queue or require 'queue'

-- local dbg = require 'debugger'

function AnimalQueue:enqueue(animal)
    self:add(animal)
end

function AnimalQueue:dequeue_any()
    return self:remove()
end

function AnimalQueue:dequeue_dog()
    return self:_dequeue_specific_animal('D')
end

function AnimalQueue:dequeue_cat()
    return self:_dequeue_specific_animal('C')
end

function AnimalQueue:_dequeue_specific_animal(animal)
    local node = self.list:find(animal)

    if node
    then
        self.list:remove_node(node)
    else
        return nil
    end

    return node.value
end

local queue = AnimalQueue:new({'C', 'D', 'C', 'C', 'C', 'D'})
queue:enqueue('C')
print(queue:dequeue_any())
print(queue:dequeue_any())
print(queue:dequeue_any())

print('look for dog:')
print(queue:dequeue_dog())

print('--- FRONT ---')
queue.list:print() -- only Cats remaining
print('--- BACK  ---')

-- Note: the author said we can use a Linked List DS, which I abuse here
--       in order to search for specific animals. However, the better
--       solution is to use two queues wrapped up inside of an Animal class
--       and you peek at both queues and remove based on the older timestamp.
--       My solution somewhat replicates that; I'm going to move on.