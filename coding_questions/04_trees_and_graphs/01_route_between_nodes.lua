--[[
    Route Between Nodes: 
    
    Given a directed graph, design an algorithm to find out whether there is a route between two nodes.
]]

-- Solution: use the DFS algorithm

local DirectionalGraph = require 'directional_graph'

local graph = DirectionalGraph:new()

graph:add_edge(0, 1)
graph:add_edge(0, 5)

graph:add_edge(2, 3)
graph:add_edge(2, 0)

graph:add_edge(3, 5)
graph:add_edge(3, 2)

graph:add_edge(4, 2)
graph:add_edge(4, 3)

graph:add_edge(5, 4)

graph:add_edge(6, 0)
graph:add_edge(6, 8)
graph:add_edge(6, 4)
graph:add_edge(6, 9)

graph:add_edge(7, 9)
graph:add_edge(7, 6)

graph:add_edge(8, 6)

graph:add_edge(9, 11)
graph:add_edge(9, 10)

graph:add_edge(10, 12)

graph:add_edge(11, 12)
graph:add_edge(11, 4)

graph:add_edge(12, 9)

graph:search(0) -- starting from zero

function display(node, graph)
    print('Node ' .. node .. ' is marked: ' .. tostring(graph:marked(node)))
end

-- true
display(1, graph)
display(2, graph)
display(3, graph)
display(4, graph)
display(5, graph)

print()

-- false
display(6, graph)
display(7, graph)
display(8, graph)
display(9, graph)
display(10, graph)
display(11, graph)
display(12, graph)
