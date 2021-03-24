--[[
    Build Order:

    You are given a list of projects and a list of dependencies (which is a list of pairs of projects, 
    where the second project is dependent on the first project). All of a project's dependencies
    must be built before the project is. Find a build order that will allow the projects to be built.
    If there is no valid build order, return an error.

    input: A B C D E F
    Dependencies: (A, D), (F, B), (B, D), (F, A), (D, C)
    output: E F A B D C
]]

local DirectionalGraph = require 'directional_graph'
-- local dbg = require 'debugger'

function create_sample_graph()
    local graph = DirectionalGraph:new()

    -- first node is dependent on second node. So, second node has to 
    -- be completed before the first node can be completed.
    graph:add_edge('A', 'F')
    graph:add_edge('B', 'F')
    graph:add_edge('C', 'D')
    graph:add_edge('D', 'B')
    graph:add_edge('D', 'A')
    -- graph:add_edge('F', 'D') -- uncomment to test if we have an infinite loop.

    return graph
end

-- this works, but i feel like all the loops add some extra inefficiencies.
function build_order(graph, input)
    local output = {}
    local reverse = graph:reverse()
    local continue_processing = true

    -- Do we still have projects?
    while #input > 0 do
        if continue_processing
        then
            continue_processing = false -- if false again, we have an error (hacky, but it works)
        else
            return nil -- error
        end

        for index, project in pairs(input) do
            -- project has no (blocking) dependencies: complete the project
            if #graph:adjacent(project) == 0
            then
                input[index] = nil
                table.insert( output, project )
                continue_processing = true

                -- loop through and signal to dependencies that projects have completed. 
                for _, dependent in ipairs(reverse:adjacent(project)) do
                    graph:remove_edge(dependent, project)
                    reverse:remove_edge(project, dependent)
                end
            end
        end
    end

    return output
end

local result = build_order(create_sample_graph(), {'A', 'B', 'C', 'D', 'E', 'F'})

if result
then
    for _, value in ipairs(result) do
        io.write(value .. ' ')
    end
else
    print('NO SOLUTION...')
end
print()
