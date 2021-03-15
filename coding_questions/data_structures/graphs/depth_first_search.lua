local DepthFirstSearch = {}
DepthFirstSearch.__index = DepthFirstSearch

local Stack = Stack or require 'stack'

local List = require "pl.List"
-- local dbg = require "debugger"

function DepthFirstSearch:new(graph, source_vertex)
    self = setmetatable({
        marked = {},
        edge_to = {},
        source_vertex = source_vertex,
        count = 0
    }, DepthFirstSearch)
    
    for i = 0, graph:V() do
        self.marked[i] = false
    end
    
    self:_validate_vertex(source_vertex)
    self:_dfs(graph, source_vertex)
    
    return self
end

function DepthFirstSearch:_dfs(graph, vertex)
   self.count = self.count + 1
   self.marked[vertex] = true

   for _, point in pairs(graph:adjacent(vertex)) do
        if not self.marked[point]
        then
            self.edge_to[point] = vertex
            self:_dfs(graph, point)
        end
    end
end

function DepthFirstSearch:has_path_to(target_vertex)
    return self.marked[target_vertex]
end

function DepthFirstSearch:path_to(target_vertex)
    if not self:has_path_to(target_vertex)
    then
        return nil
    end

    -- loop through the points and give us a direct path to target
    local x = target_vertex
    local stack = Stack:new()
    while x ~= self.source_vertex do
        stack:push(x)
        x = self.edge_to[x]
    end
    stack:push(self.source_vertex)

    return stack:values()
end

function DepthFirstSearch:_validate_vertex(vertex)
    local max_length = #self.marked
    if vertex < 0 or vertex > max_length
    then
        print("Vertex [" .. vertex .. "] is not between 0 and " .. max_length)
        os.exit(1) -- fail
    end
end

return DepthFirstSearch
