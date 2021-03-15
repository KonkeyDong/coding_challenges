local DirectedDepthFirstSearch = {}
DirectedDepthFirstSearch.__index = DirectedDepthFirstSearch

local Queue = Queue or require "queue"
local Stack = Stack or require 'stack'

function DirectedDepthFirstSearch:new(graph, source_vertex)
    self = setmetatable({
        marked = {},
    }, DirectedDepthFirstSearch)

    for i = 0, graph:V() do
        self.marked[i] = false
    end

    self:_dfs(graph, source_vertex)

    return self
end

function DirectedDepthFirstSearch:_dfs(graph, vertex)
    self.marked[vertex] = true

    for _, point in pairs(graph:adjacent(vertex)) do
        if not self.marked[point]
        then
            self:_dfs(graph, point)
        end
    end
end

function DirectedDepthFirstSearch:is_marked(vertex)
    return self.marked[vertex]
end

return DirectedDepthFirstSearch
