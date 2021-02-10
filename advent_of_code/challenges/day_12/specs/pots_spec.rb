require 'minitest/autorun'
require 'byebug'
require_relative '../pots'
require_relative '../double_linked_list'

describe Pots do
    before do
        @pots = Pots.new('test_01.txt')
    end

    # describe "#initialize" do
    #     it "should set @pots to matching array" do
    #         assert_equal @pots.pots.to_a, %w(. . . . . # . . # . # . . # # . . . . . . # # # . . . # # # . . . . .)
    #     end


    #     it "should set the patterns hash (assume all patterns if a pattern is in the hash)" do
    #         assert_equal @pots.patterns["...##"], "#"
    #     end
    # end

    # describe "#find_pattern" do
    #     it "should return #" do
    #         node = get_nth_node(9)
    #         assert_equal @pots.send(:find_pattern, node), "#"
    #     end

    #     it "should return nil" do
    #         node = get_nth_node(10)
    #         assert_nil @pots.send(:find_pattern, node)
    #     end

    #     def get_nth_node(n)
    #         node = @pots.pots.head
    #         n.times { node = node.next }
    #         node
    #     end
    # end

    # describe "#expand_pots?" do
    #     let(:left_pots)  { %w(. . # . . . . . . . . . . . .) }
    #     let(:right_pots) { %w(. . . . . . . . . . . . # . .) }
    #     let(:empty_pots) { %w(. . . . . . . . . . . . . . .) }

    #     it "should return true" do
    #         set_pots(left_pots)
    #         assert_pots(true)

    #         set_pots(right_pots)
    #         assert_pots(true)
    #     end

    #     it "should return false" do
    #         set_pots(empty_pots)
    #         assert_pots(false)
    #     end

    #     def set_pots(pots)
    #         @pots.instance_variable_set("@pots", DoubleLinkedList.new(pots))
    #     end

    #     def assert_pots(boolean)
    #         assert_equal @pots.send(:expand_pots?), boolean
    #     end
    # end

    # describe "#generate" do
    #     it "should resemble the new array after one generation" do
    #         @pots.instance_variable_set("@generation_limit", 1)

    #         # initial
    #         assert_equal @pots.pots.to_a, %w(. . . . . # . . # . # . . # # . . . . . . # # # . . . # # # . . . . .)
    #         @pots.generate(1)

    #         # 1st generation
    #         assert_equal @pots.pots.to_a, %w(. . . . . # . . # # # . . # # . . . . . # # # # . . # # # # . . . . .)
    #     end
    # end

    describe "#count_plants" do
        # it "should equal 185 after 1 generation" do
        #     pots = Pots.new("test_01.txt")
        #     pots.generate(1)
        #     assert_equal pots.count_plants, 185
        # end

        # it "should equal 224 after 20 generations" do
        #     pots = Pots.new("test_01.txt")
        #     pots.generate(20)
        #     assert_equal pots.count_plants, 224
        # end

        it "should equal 3793 after 20 generations using the non-test file" do
            pots = Pots.new("../challenge.txt")
            pots.generate(20)
            assert_equal pots.count_plants, 3793
        end
    end
end