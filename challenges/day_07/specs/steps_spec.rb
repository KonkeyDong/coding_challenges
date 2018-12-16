require 'minitest/autorun'
require_relative '../graph'

describe Graph do
    let(:example_step1) { "Step C must be finished before step A can begin." }
    let(:example_step2) { "Step C must be finished before step X can begin." }


    before do
        @graph = Graph.new('test_01.txt')
    end

    describe "#parse_start" do
        it "Should return 'C'" do
            assert_equal @graph.send(:parse_start, example_step1), "C"
        end
    end

    describe "#parse_final" do
        it "should return 'A'" do
            assert_equal @graph.send(:parse_final, example_step1), "A"
        end
    end

    describe "#add_connection and #add_next" do
        let(:example_data) {
            {
                "C" => { next: { "A" => true }, prev: {} }
            }
        }

        describe "#add_connection" do
            it "should set @graph to the example_data" do
                assert_equal @graph.instance_variable_get("@graph"), {}
                @graph.send(:add_connection, "C", "A", :next)
                assert_equal @graph.instance_variable_get("@graph"), example_data
            end
        end

        describe "#add_next" do
            it "should set @graph to the example_data" do
                assert_equal @graph.instance_variable_get("@graph"), {}
                @graph.send(:add_next, "C", "A")
                assert_equal @graph.instance_variable_get("@graph"), example_data
            end
        end
    end

    describe "#add_prev" do
        let(:example_data) {
            {
                "A" => { prev: { "C" => true }, next: {} }
            }
        }

        it "should set @graph to the example_data" do
            assert_equal @graph.instance_variable_get("@graph"), {}
            @graph.send(:add_prev, "C", "A")
            assert_equal @graph.instance_variable_get("@graph"), example_data
        end
    end

    describe "#default_tree" do
        let(:example_data1) {
            {
                'X' => { 
                    next: {}, 
                    prev: {}
                }
            }
        }

        let(:example_data2) {
            example_data1.merge(
                "X" => { next: { "Y" => true }, prev: {} }
            )
        }

        it "should add a hash similar to the example_default_tree value" do
            assert_equal @graph.instance_variable_get("@graph"), {}
            @graph.send(:default_tree, "X")
            assert_equal @graph.instance_variable_get("@graph"), example_data1
        end

        it "should NOT overwrite the tree if one already exists" do
            assert_equal @graph.instance_variable_get("@graph"), {}
            @graph.send(:default_tree, "X")
            assert_equal @graph.instance_variable_get("@graph"), example_data1

            @graph.send(:add_next, "X", "Y")
            assert_equal @graph.instance_variable_get("@graph"), example_data2

            @graph.send(:default_tree, "X")
            assert_equal @graph.instance_variable_get("@graph"), example_data2
        end
    end

    describe "#add_step_to_graph" do
        let(:c_next) { { next: { "A" => true } } }
        let(:a_prev) { { prev: { "C" => true } } }
        let(:x_prev) { { prev: { "C" => true } } }
        
        let(:first_graph) {
            {
                "C" => { **c_next, prev: {} },
                "A" => { next: {}, **a_prev }
            }
        }

        let(:second_graph) {
            {
                "C" => { next: first_graph["C"][:next].merge("X" => true), prev: {} },
                "A" => first_graph["A"],
                "X" => { next: {}, **x_prev }
            }
        }

        it "should set @graph to { 'C' => ['A'] }" do
            assert_equal @graph.instance_variable_get("@graph"), {}
            @graph.send(:add_step_to_graph, example_step1)
            assert_equal @graph.instance_variable_get("@graph"), first_graph
            
            @graph.send(:add_step_to_graph, example_step2)
            assert_equal @graph.instance_variable_get("@graph"), second_graph
        end
    end

    describe "#can_complete_step?" do
        it "should return true" do
            @graph.send(:add_step_to_graph, example_step1)
            assert_equal @graph.send(:can_complete_step?, "C"), true
        end

        it "should return false" do
            @graph.send(:add_step_to_graph, example_step1)
            assert_equal @graph.send(:can_complete_step?, "A"), false
        end

        it "should return true if no :prev hash" do
            assert_equal @graph.send(:can_complete_step?, "C"), true
        end
    end

    describe "#get_next_steps" do
        it "should return an array of the next steps in a step" do
            @graph.send(:add_step_to_graph, example_step2)
            @graph.send(:add_step_to_graph, example_step1)
            assert_equal @graph.send(:get_next_steps, "C"), %w(X A)
        end
    end

    describe "#complete_step and #add_available_steps" do
        it "should add 'C' to @completed_steps; add 'A' and 'X' to @available_steps" do
            @graph.send(:add_step_to_graph, example_step1)
            @graph.send(:add_step_to_graph, example_step2)
            @graph.instance_variable_set("@available_steps", %w(C))
            @graph.send(:complete_step, "C")
            assert_equal @graph.instance_variable_get("@completed_steps"), %w(C)
            
            @graph.send(:add_available_steps, "C")
            assert_equal @graph.instance_variable_get("@available_steps"), %w(A X)
        end
    end

    describe "#remove_prerequisites" do
        it "should remove 'C' from 'A' :prev hash" do
            @graph.send(:add_step_to_graph, example_step1)
            @graph.send(:add_step_to_graph, example_step2)
            @graph.send(:remove_prerequisites, "A", "C")
            
            assert_equal @graph.instance_variable_get("@graph")["A"][:prev], {}
            assert_equal @graph.instance_variable_get("@graph")["X"][:prev], { "C" => true }
        end
    end

    describe "#traverse" do
        it "should return 'CABDFE'" do
            assert_equal @graph.traverse, "CABDFE"
        end
    end

    describe "#find_no_prev_nodes" do
        it "should return 'C'" do
            @graph.send(:add_step_to_graph, example_step1)
            @graph.send(:add_step_to_graph, example_step2)
            assert_equal @graph.send(:find_no_prev_nodes), ["C"]
        end
    end

    describe "#set_initial_available_steps" do
        let(:example_step3) { "Step D must be finished before step T can begin." }

        it "should return ['C', 'D']" do
            @graph.send(:add_step_to_graph, example_step3)
            @graph.send(:add_step_to_graph, example_step1)
            assert_equal @graph.send(:set_initial_available_steps, 
                                     @graph.send(:find_no_prev_nodes)), 
                %w(C D)
        end
    end
end
