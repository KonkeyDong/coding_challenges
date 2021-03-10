local DepthFirstSearch = {}
DepthFirstSearch.__index = DepthFirstSearch

local List = require "pl.List"
-- local dbg = require "debugger"

function DepthFirstSearch:new(graph, source_vertex)
    self = setmetatable({
        marked = {},
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

   for _, v in pairs(graph:adjacent(vertex)) do
        if not self.marked[v]
        then
            self:_dfs(graph, v)
        end
   end
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
