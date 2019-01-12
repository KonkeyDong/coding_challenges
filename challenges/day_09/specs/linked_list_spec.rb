require 'minitest/autorun'
require_relative '../linked_list'

describe 'linked list' do
    before do
        @ll = LinkedList.new(0)
    end

    describe "#add" do
        it 'should add new nodes and move the @root value to the recently added value' do
            (1..6).each do |i|
                add_helper(i, i-1)
            end

            assert_equal @ll.print_list_next, "0425163"
            assert_equal @ll.print_list_prev, "0361524"
        end

        def add_helper(value, old_value)
            assert_equal @ll.root.value, old_value
            @ll.add(value)
            assert_equal @ll.root.value, value
        end
    end

    describe "#remove" do
        it "should remove 7 to the left and return the value" do
            (1..8).each do |i|
                @ll.add(i)
            end

            assert_equal @ll.print_list_next, "084251637"
            assert_equal @ll.remove, 2
            assert_equal @ll.print_list_next, "08451637"
        end
    end
end
