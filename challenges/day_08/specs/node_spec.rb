require 'minitest/autorun'
require_relative '../node'

describe Node do
    before do
        @node = Node.new(2, 3)
    end

    describe "#add_metadata" do
        it "should add a number to @metadata and error if exceeding the buffer limit" do
            @node.add_metadata(7)
            @node.add_metadata(8)
            @node.add_metadata(9)
            assert_equal @node.metadata, [7, 8, 9]

            @node.stub :error, "bologna" do
                assert_equal @node.add_metadata(1), "bologna"
            end
        end
    end

    describe "#add_child" do
        it "should add a new node to @children and error if exceeding the buffer limit" do
            @node.add_child(Node.new(1, 1))
            @node.add_child(Node.new(1, 1))
            assert_equal @node.children.size, 2

            @node.stub :error, "bologna" do
                assert_equal @node.add_child(Node.new(1, 1)), "bologna"
            end
        end
    end
end
