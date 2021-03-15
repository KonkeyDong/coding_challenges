local DirectionalGraph = DirectionalGraph or require 'directional_graph'

require "busted"

local List = require 'pl.List'
-- local dbg = require 'debugger'

describe('DirectionalGraph', function()
    io.write('\nDirectional Graph Tests: ')
    describe(':add_edge()', function()
        it('should add 2 vertexes and 1 edge', function()
            local graph = DirectionalGraph:new()
            graph:add_edge(1, 2)

            assert.is_equal(graph:V(), 2)
            assert.is_equal(graph:E(), 1)
            assert.are.same(graph:adjacent(1), {2})
            assert.are.same(graph:adjacent(2), {})
        end)

        it('should add 2 vertexes and 2 edges', function()
            local graph = DirectionalGraph:new()
            graph:add_edge(1, 2)
            graph:add_edge(2, 1)

            assert.is_equal(graph:V(), 2)
            assert.is_equal(graph:E(), 2)
            assert.are.same(graph:adjacent(1), {2})
            assert.are.same(graph:adjacent(2), {1})
        end)
    end)

    describe(':out_degree()', function()
        it('should have 1 out degree from vertex 1 and 0 from vertex 2', function()
            local graph = DirectionalGraph:new()
            graph:add_edge(1, 2)

            assert.is_equal(graph:out_degree(1), 1)
            assert.is_equal(graph:out_degree(2), 0)
        end)
    end)

    describe(':in_degree()', function()
        it('should have 0 in degrees from vertex 1 and 1 from vertex 2', function()
            local graph = DirectionalGraph:new()
            graph:add_edge(1, 2)

            assert.is_equal(graph:in_degree(1), 0)
            assert.is_equal(graph:in_degree(2), 1)
        end)
    end)

    describe(':reverse()', function()
        local graph = DirectionalGraph:new()
        graph:add_edge(1, 2)
        graph:add_edge(1, 3)
        graph:add_edge(1, 4)

        graph:add_edge(2, 3)
        graph:add_edge(0, 1)

        local reverse = graph:reverse()

        assert.is_equal(graph:V(), 3)
        assert.is_equal(reverse:V(), 4)

        assert.is_equal(graph:E(), 5)
        assert.is_equal(reverse:E(), 5)

        assert.are.same(graph:adjacent(1), {2, 3, 4})
        assert.are.same(reverse:adjacent(1), {0})
    end)

    describe(':search()', function()
        function create_graph()
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
            
            return graph
        end

        it('should mark all paths starting from 0', function()
            local graph = create_graph()
            graph:search(0)

            assert.is_true(graph:marked(1)) -- 0 -> 1
            assert.is_true(graph:marked(2)) -- 0 -> 5 -> 4 -> 2
            assert.is_true(graph:marked(3)) -- 0 -> 5 -> 4 -> 3
            assert.is_true(graph:marked(4)) -- 0 -> 5 -> 4
            assert.is_true(graph:marked(5)) -- 0 -> 5

            for x in List.new({6, 7, 8 ,9 ,10, 11, 12}):iter() do
                assert.is_false(graph:marked(x))
            end

            assert.is_equal(graph:V(), 13)
            assert.is_equal(graph:E(), 22)
        end)
    end)
end)
