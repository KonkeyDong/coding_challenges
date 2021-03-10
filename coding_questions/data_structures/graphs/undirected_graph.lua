-- The following data structure is based off of this implementation: https://algs4.cs.princeton.edu/41graph/

local UndirectedGraph = {}
UndirectedGraph.__index = UndirectedGraph

-- local dbg = require "debugger"

local abspath = require('pl.path').abspath  --.abspath('..')
package.path = package.path .. ';' .. abspath('..') .. '/?.lua'
package.path = package.path .. ';' .. abspath('.') .. '/?.lua'
local DepthFirstSearch = DepthFirstSearch or require 'depth_first_search'
local LinkedList = LinkedList or require "linked_list"

local seq = require "pl.seq"
-- local dbg = require 'debugger'

-- create a v-vertex graph with no edges
function UndirectedGraph:new()
    self = setmetatable({
        vertices = {},
        vertex_count = 0,
        edge_count = 0
    }, UndirectedGraph)

    return self
end

function UndirectedGraph:V()
    return self.vertex_count
end

function UndirectedGraph:E()
    return self.edge_count
end

function UndirectedGraph:search(source_vertex)
    self.depth_first_search = DepthFirstSearch:new(self, source_vertex)
end

function UndirectedGraph:connected(source_vertex, destination_vertex)
    if not self.depth_first_search
    then
        self:search(source_vertex)
    end

    return self.depth_first_search.marked[destination_vertex]
end

-- since this is undirectional, we have to update the linked list
-- in both the vertex and the edge's linked lists
function UndirectedGraph:add_edge(vertex, edge)
    if not self.vertices[vertex]
    then
        -- create the linked list from the edge with the vertex in its values
        self:_check_and_create_linked_list(vertex, edge)
        self:_check_and_create_linked_list(edge, vertex)

        self:_increment_edge_count()
    else  
        self:_check_and_create_linked_list(edge, vertex)
        
        local x = self:_check_and_add_edge(vertex, edge)
        local y = self:_check_and_add_edge(edge, vertex)

        if x or y
        then
            self:_increment_edge_count()
        end
    end
end

-- create the linked list from the edge with the vertex in its values
function UndirectedGraph:_check_and_create_linked_list(vertex, edge)
    if not self.vertices[vertex]
    then
        self.vertices[vertex] = LinkedList:new({edge})
        self:_increment_vertex_count()
    end
end

function UndirectedGraph:_check_and_add_edge(vertex, edge)
    if not self.vertices[vertex]:find(edge)
    then
        self.vertices[vertex]:add(edge)
        return true
    end

    return false
end

function UndirectedGraph:adjacent(vertex)
    if not self.vertices[vertex]
    then
        return {}
    end
    
    return self.vertices[vertex]:values()
end

function UndirectedGraph:_increment_vertex_count()
    self.vertex_count = self.vertex_count + 1
end

function UndirectedGraph:_increment_edge_count()
    self.edge_count = self.edge_count + 1
end

return UndirectedGraph
