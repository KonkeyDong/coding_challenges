require 'minitest/autorun'
require_relative '../tree'

describe Tree do
    before do
        @tree = Tree.new('test_01.txt')
    end

    describe "#build" do
        it "should parse out children and metadata" do
            @tree.build
            assert_equal @tree.root.metadata, [1, 1, 2]
            assert_equal @tree.root.children[0].metadata, [10, 11, 12]
            assert_equal @tree.root.children[1].metadata, [2]
            assert_equal @tree.root.children[1].children[0].metadata, [99]
        end
    end

    describe "#sum_metadata" do
        it "should return 138" do
            @tree.build
            assert_equal @tree.sum_metadata, 138
        end
    end

    describe "#sum_root" do
        it "should return 66" do
            @tree.build
            assert_equal @tree.sum_root, 66
        end
    end
end
