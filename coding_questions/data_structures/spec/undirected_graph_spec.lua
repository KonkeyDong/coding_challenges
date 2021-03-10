local path = require 'pl.path'.abspath('../data_structures/graphs')
package.path = package.path .. ';' .. path .. '/?.lua'
local UndirectedGraph = UndirectedGraph or require 'undirected_graph'

require "busted"
-- local dbg = require "debugger"

describe('UndirectedGraph', function()
    io.write('\nUndirected Graph Tests: ')
    describe(':add_edge()', function()
        it('should create a new LinkedList in an adjacency list', function()
            local graph = UndirectedGraph:new()
            assert.is_nil(graph.vertices[1])
            assert.is_equal(graph:V(), 0)
            assert.is_equal(graph:E(), 0)
            
            graph:add_edge(1, 2)
            assert.is_equal(type(graph.vertices[1]), 'table')
            assert.is_equal(graph:V(), 2)
            assert.is_equal(graph:E(), 1)
            assert.are.same(graph:adjacent(1), { 2 })

            graph:add_edge(1, 3)
            assert.is_equal(graph:V(), 3)
            assert.is_equal(graph:E(), 2)
            assert.are.same(graph:adjacent(1), { 2, 3 })
        end)

        it('should create two LinkedLists in adjacency list', function()
            local graph = UndirectedGraph:new()
            graph:add_edge(0, 1)
            graph:add_edge(1, 0)
            graph:add_edge(1, 2)
            graph:add_edge(2, 1)
            
            assert.is_equal(graph:V(), 3)
            assert.is_equal(graph:E(), 2)
            assert.are.same(graph:adjacent(0), { 1 })
            assert.are.same(graph:adjacent(1), { 0, 2 })
            assert.are.same(graph:adjacent(2), { 1 })
        end)
    end)

    describe(':search()', function()
        -- see /images/graph.jpg for a drawing of the graph below.
        function create_graph()
            local graph = UndirectedGraph:new()
            graph:add_edge(0, 6)
            graph:add_edge(0, 2)
            graph:add_edge(0, 1)
            graph:add_edge(0, 5)

            graph:add_edge(1, 0)
            graph:add_edge(2, 0)

            graph:add_edge(3, 5)
            graph:add_edge(3, 4)

            graph:add_edge(4, 5)
            graph:add_edge(4, 6)
            graph:add_edge(4, 3)

            graph:add_edge(5, 3)
            graph:add_edge(5, 4)
            graph:add_edge(5, 0)

            graph:add_edge(6, 0)
            graph:add_edge(6, 4)

            graph:add_edge(7, 8)

            graph:add_edge(8, 7)

            graph:add_edge(9, 11)
            graph:add_edge(9, 10)
            graph:add_edge(9, 12)

            graph:add_edge(10, 9)

            graph:add_edge(11, 9)
            graph:add_edge(11, 12)

            graph:add_edge(12, 11)
            graph:add_edge(12, 9)

            return graph
        end

        it('should have a connection', function()
            local graph = create_graph()
            graph:search(1)
            assert.is_true(graph:connected(1, 2))
            assert.is_false(graph:connected(1, 9))
            assert.is_equal(graph:V(), 13)
            assert.is_equal(graph:E(), 14)

            local test_data = { }
            test_data[0]  = true
            test_data[1]  = true
            test_data[2]  = true
            test_data[3]  = true
            test_data[4]  = true
            test_data[5]  = true
            test_data[6]  = true
            test_data[7]  = false
            test_data[8]  = false
            test_data[9]  = false
            test_data[10] = false
            test_data[11] = false
            test_data[12] = false
            test_data[13] = false

            assert.are.same(graph.depth_first_search.marked, test_data)
        end)

        it('should have different connections', function()
            local graph = create_graph()
            graph:search(7)
            assert.is_false(graph:connected(1, 3))
            assert.is_true(graph:connected(7, 8))

            local test_data = { }
            test_data[0]  = false
            test_data[1]  = false
            test_data[2]  = false
            test_data[3]  = false
            test_data[4]  = false
            test_data[5]  = false
            test_data[6]  = false
            test_data[7]  = true
            test_data[8]  = true
            test_data[9]  = false
            test_data[10] = false
            test_data[11] = false
            test_data[12] = false
            test_data[13] = false

            assert.are.same(graph.depth_first_search.marked, test_data)
        end)
    end)
end)
