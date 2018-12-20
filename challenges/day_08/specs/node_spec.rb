require 'minitest/autorun'
require 'byebug'
require_relative '../node'

describe Node do
    before do
        mock
    end

    describe "#add_metadata" do
        it "should add a number to @metadata and error if exceeding the buffer limit" do
            assert_equal @node.metadata, [1, 2, 3]

            @node.stub :error, "bologna" do
                assert_equal @node.add_metadata(1), "bologna"
            end
        end
    end

    describe "#add_child" do
        it "should add a new node to @children and error if exceeding the buffer limit" do
            assert_equal @node.children.size, 2

            @node.stub :error, "bologna" do
                assert_equal @node.add_child(Node.new(1, 1)), "bologna"
            end
        end
    end

    describe "#has_children?" do
        it "should return true" do
            assert_equal @node.send(:has_children?, @node), true
        end

        it "should return false" do
            child = @node.children[0]
            assert_equal child.send(:has_children?, child), false
        end
    end

    describe "#out_of_range?" do
        it "should return true" do
            assert_equal @node.send(:out_of_range?, @node, 4), true
        end

        it "should return false" do
            assert_equal @node.send(:out_of_range?, @node, 1), false
        end
    end

    describe "#add_root_value" do
        it "should return 1 if no children" do
            assert_equal @node.add_root_value(@node.children[0]), 4
            # TODO: mock has_children? to fail to test cache
        end

        it "should return 4" do
            assert_equal @node.add_root_value(@node), 4
        end
    end

    def mock
        @node = Node.new(2, 3) # children, metadata
        @node.add_metadata(1)
        @node.add_metadata(2)
        @node.add_metadata(3)

        @node.add_child(Node.new(0, 1))
        @node.children[0].add_metadata(4)

        @node.add_child(Node.new(1, 1))
        @node.children[1].add_metadata(5)

        @node.children[1].add_child(Node.new(0, 1))
        @node.children[1].children[0].add_metadata(6)
    end
end
