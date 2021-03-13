local path = require 'pl.path'.abspath('..')
package.path = package.path .. ';' .. path .. '/?.lua'
local BinaryTree = BinaryTree or require 'binary_tree'

-- local dbg = require 'debugger'
local TEST_DATA = {5, 3, 7, 1, 2, 6, 8}


describe('BinaryTree', function()
    io.write('\nBinaryTree Tests: ')
    describe(':add()', function()
        it('should add a root node', function()
            local bt = BinaryTree:new()
            bt:add(5)

            assert.is_equal(bt.root.value, 5)
            assert.is_equal(bt.count, 1)
            assert.is_nil(bt.root.left)
            assert.is_nil(bt.root.right)
        end)

        it('should create a tree with a left and right node', function()
            local bt = BinaryTree:new()
            bt:add(5)
            bt:add(3)
            bt:add(7)

            assert.is_equal(bt.count, 3)
            assert.is_equal(bt.root.left.value, 3)
            assert.is_equal(bt.root.right.value, 7)
            assert.is_equal(bt.root.left.up.value, 5)
            assert.is_equal(bt.root.right.up.value, 5)
        end)

        it('should NOT create a duplicate node (no increment to count)', function()
            local bt = BinaryTree:new()
            bt:add(5)
            bt:add(5)

            assert.is_equal(bt.count, 1)
            assert.is_equal(bt.root.value, 5)
            assert.is_nil(bt.left)
            assert.is_nil(bt.right)
        end)
    end)

    describe(':find()', function()
        it('should find the value', function()
            local bt = BinaryTree:new(TEST_DATA)

            assert.is_equal(bt.count, 7)
            assert.is_equal(bt:search(8), 8)
        end)

        it('should NOT find a value (return nil)', function()
            local bt = BinaryTree:new(TEST_DATA)

            assert.is_nil(bt:search(99))
        end)
    end)

    describe(':in_order_traversal()', function()
        it('should return data', function()
            local bt = BinaryTree:new(TEST_DATA)

            assert.are.same(bt:in_order_traversal(), {1, 2, 3, 5, 6, 7, 8})
        end)
    end)

    describe(':pre_order_traversal()', function()
        it('should return data', function()
            local bt = BinaryTree:new(TEST_DATA)

            assert.are.same(bt:pre_order_traversal(), {5, 3, 1, 2, 7, 6, 8})
        end)
    end)

    describe(':post_order_traversal()', function()
        it('should return data', function()
            local bt = BinaryTree:new(TEST_DATA)
    
            assert.are.same(bt:post_order_traversal(), {2, 1, 3, 6, 8, 7, 5})
        end)
    end)

    describe(':minimum()', function()
        it('should return the minimum value', function()
            local bt = BinaryTree:new(TEST_DATA)

            assert.is_equal(bt:minimum(), 1)
        end)
    end)

    describe(':maximum()', function()
        it('should return the maximum value', function()
            local bt = BinaryTree:new(TEST_DATA)

            assert.is_equal(bt:maximum(), 8)
        end)
    end)

    describe(':delete()', function()
        it('should remove the specific value with no leaves', function()
            local bt = BinaryTree:new(TEST_DATA)
            assert.is_equal(bt.count, 7)
            bt:delete(2)

            assert.are.same(bt:in_order_traversal(), {1, 3, 5, 6, 7, 8})
            assert.is_equal(bt.count, 6)
        end)

        it('should remove the specific value with 1 leaf', function()
            local bt = BinaryTree:new(TEST_DATA)
            assert.is_equal(bt.count, 7)
            bt:delete(1)

            assert.are.same(bt:in_order_traversal(), {2, 3, 5, 6, 7, 8})
            assert.is_equal(bt.count, 6)
        end)

        it('should remove the specific value with 2 leaves', function()
            local bt = BinaryTree:new(TEST_DATA)
            assert.is_equal(bt.count, 7)
            bt:delete(5)

            assert.are.same(bt:in_order_traversal(), {1, 2, 3, 6, 7, 8})
            assert.is_equal(bt.count, 6)
        end)
    end)
end)