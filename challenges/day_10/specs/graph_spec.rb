require 'minitest/autorun'
require 'byebug'
require_relative '../graph'

describe Graph do
    describe "Parsing" do
        let(:example_line) { "position=< 9,  1> velocity=< 0,  2>" }

        describe "#parse_position" do
            it "should return x: 9, y: 1" do
                graph = Graph.new("test_01.txt")
                assert_equal graph.send(:parse_position, example_line), {x: 9, y: 1}
            end
        end

        describe "#parse_velocity" do
            it "should return x: 0, y: 2" do
                graph = Graph.new("test_01.txt")
                assert_equal graph.send(:parse_velocity, example_line), {x: 0, y: 2}
            end
        end

        describe "#parse_line" do
            let(:data) {
                {
                    position: { x: 9, y: 1 },
                    velocity: { x: 0, y: 2 }
                }
            }

            it "should return the appropiate hash" do
                graph = Graph.new("test_01.txt")
                assert_equal graph.send(:parse_line, example_line), data
            end
        end
    end

    describe "#initialize_graph" do
        it "should return 31 points" do
            graph = Graph.new("test_01.txt")
            graph.initialize_graph
            
            assert_equal graph.number_of_points, 31
        end
    end

    describe "#find_message" do
        it "should return 4 iterations" do
            graph = Graph.new("test_01.txt")
            graph.initialize_graph
            assert_equal graph.find_message, 3
        end
    end
end