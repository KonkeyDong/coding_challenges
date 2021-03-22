--- A class representing a DirectionalGraph (DiGraph)
-- @classmod DirectionalGraph
-- @author KonkeyDong

local DirectionalGraph = {}
DirectionalGraph.__index = DirectionalGraph

local DirectedDepthFirstSearch = DirectedDepthFirstSearch or require 'directed_depth_first_search'
local LinkedList = LinkedList or require 'linked_list'
local List = require 'pl.List'
-- local dbg = require 'debugger'

--- Constructor.
-- @return The instance of the object.
function DirectionalGraph:new()
    self = setmetatable({
        vertices = {},
        vertex_count = 0,
        edge_count = 0,
        in_degree_data = {}
    }, DirectionalGraph)

    return self
end

function DirectionalGraph:search(source_vertex)
    self.depth_first_search = DirectedDepthFirstSearch:new(self, source_vertex)
end

--- Determine if a vertex can be found found in the DiGraph, starting with source_vertex in :search()
-- @param vertex The vertex to search for
-- @return True if the vertex was marked off, false otherwise. If :search() wasn't called, returns nil.
function DirectionalGraph:marked(vertex)
    if not self.depth_first_search
    then
        return nil
    end

    return self.depth_first_search:is_marked(vertex)
end

--- How many vertices were created.
-- @return The number of vertices created
function DirectionalGraph:V()
    return self.vertex_count
end

--- How many edges were created.
-- @return The number of edges created.
function DirectionalGraph:E()
    return self.edge_count
end

--- Add an edge from source_vertex (sv) to target_vertex (tv): sv -> tv
-- @param source_vertex The starting vertex
-- @param target_vertex The target vertex
function DirectionalGraph:add_edge(source_vertex, target_vertex)
    -- create a new linked list if the Adj. list element is empty.
    if not self.vertices[source_vertex]
    then
        self:_check_and_create_linked_list(source_vertex, target_vertex)
        self:_check_and_create_linked_list(target_vertex)
    else
        self.vertices[source_vertex]:add(target_vertex)
    end

    self:_increment_in_degree(target_vertex)
    self:_increment_edge_count()
end

function DirectionalGraph:remove_edge(source_vertex, target_vertex)
    if self.vertices[source_vertex]
    then
        local linked_list = self.vertices[source_vertex]
        local node = linked_list:find(target_vertex)

        if node
        then
            linked_list:remove_all_instances(node.value)
            self:_decrement_edge_count()
        end
    end
end

function DirectionalGraph:_check_and_create_linked_list(vertex, edge)
    if not self.vertices[vertex]
    then
        self.vertices[vertex] = LinkedList:new({edge})
        self:_increment_vertex_count()
    end
end

--- Vertices connected to V by edges pointing from V.
-- @param vertex The starting vertex
-- @return An array of directed edges from V. Returns an empty table if starting V is not found.
function DirectionalGraph:adjacent(vertex)
    if not self.vertices[vertex]
    then
        return {}
    end

    return self.vertices[vertex]:values()
end

--- Returns the number of directed edges going OUT FROM a vertex.
-- @param vertex A vertex.
-- @return The count (out degree) of the vertex.
function DirectionalGraph:out_degree(vertex)
    return self.vertices[vertex].count
end

--- Returns the number of directed edges going IN TO a vertex.
-- @param vertex A vertex.
-- @return The count (in degree) of the vertex.
function DirectionalGraph:in_degree(vertex)
    return self.in_degree_data[vertex] or 0
end

--- Returns the reverse of a graph
-- @return A new graph that is the reverse of a Directional Graph.
function DirectionalGraph:reverse()
    local reverse = DirectionalGraph:new()

    for v in List.new(self:_get_list_of_vertices()):iter() do
        for e in List.new(self:adjacent(v)):iter() do
            reverse:add_edge(e, v)
        end
    end
    
    return reverse
end

function DirectionalGraph:_get_list_of_vertices()
    local result = {}

    for k, _ in pairs(self.vertices) do
        table.insert(result, k)
    end
    
    return result
end

function DirectionalGraph:_increment_vertex_count()
    self.vertex_count = self.vertex_count + 1
end

function DirectionalGraph:_increment_edge_count()
    self.edge_count = self.edge_count + 1
end

function DirectionalGraph:_decrement_edge_count()
    self.edge_count = self.edge_count - 1
end

function DirectionalGraph:_increment_in_degree(vertex)
    if not self.in_degree_data[vertex]
    then
        self.in_degree_data[vertex] = 0
    end

    self.in_degree_data[vertex] = self.in_degree_data[vertex] + 1
end

return DirectionalGraph