require 'minitest/autorun'
require_relative '../graph'

describe Graph do
    let(:example_step1) { "Step C must be finished before step A can begin." }
    let(:example_step2) { "Step C must be finished before step X can begin." }
    let(:example_step3) { "Step D must be finished before step T can begin." }
    let(:example_step4) { "Step G must be finished before step N can begin." }

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

    describe "#default_node" do
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

        it "should add a hash similar to the example_default_node value" do
            assert_equal @graph.instance_variable_get("@graph"), {}
            @graph.send(:default_node, "X")
            assert_equal @graph.instance_variable_get("@graph"), example_data1
        end

        it "should NOT overwrite the tree if one already exists" do
            assert_equal @graph.instance_variable_get("@graph"), {}
            @graph.send(:default_node, "X")
            assert_equal @graph.instance_variable_get("@graph"), example_data1

            @graph.send(:add_next, "X", "Y")
            assert_equal @graph.instance_variable_get("@graph"), example_data2

            @graph.send(:default_node, "X")
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
            add_step_to_graph(example_step1)
            assert_equal @graph.instance_variable_get("@graph"), first_graph
            
            add_step_to_graph(example_step2)
            assert_equal @graph.instance_variable_get("@graph"), second_graph
        end
    end

    describe "#can_complete_step?" do
        it "should return true" do
            add_step_to_graph(example_step1)
            assert_equal @graph.send(:can_complete_step?, "C"), true
        end

        it "should return false" do
            add_step_to_graph(example_step1)
            assert_equal @graph.send(:can_complete_step?, "A"), false
        end

        it "should return true if no :prev hash" do
            assert_equal @graph.send(:can_complete_step?, "C"), true
        end
    end

    describe "#get_next_steps" do
        it "should return an array of the next steps in a step" do
            add_step_to_graph(example_step2)
            add_step_to_graph(example_step1)
            assert_equal @graph.send(:get_next_steps, "C"), %w(X A)
        end
    end

    describe "#complete_step and #add_available_steps" do
        it "should add 'C' to @completed_steps; add 'A' and 'X' to @available_steps" do
            add_step_to_graph(example_step1)
            add_step_to_graph(example_step2)
            @graph.instance_variable_set("@available_steps", %w(C))
            @graph.send(:complete_step, "C")
            assert_equal @graph.instance_variable_get("@completed_steps"), %w(C)
            
            @graph.send(:add_available_steps, "C")
            assert_equal @graph.instance_variable_get("@available_steps"), %w(A X)
        end
    end

    describe "#remove_prerequisites" do
        it "should remove 'C' from 'A' :prev hash" do
            add_step_to_graph(example_step1)
            add_step_to_graph(example_step2)
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

    describe "#find_no_previous_nodes" do
        it "should return 'C'" do
            add_step_to_graph(example_step1)
            add_step_to_graph(example_step2)
            assert_equal @graph.send(:find_no_previous_nodes), ["C"]
        end
    end

    describe "#set_initial_available_steps" do
        it "should return ['D', 'C']" do
            add_step_to_graph(example_step3)
            add_step_to_graph(example_step1)

            assert_equal @graph.send(:set_initial_available_steps), %w(D C)
        end
    end

    describe "#workers_available?" do
        it "should return true" do
            set_number_of_workers(2)
            @graph.instance_variable_set("@workers", { "bologna" => true })
            assert_equal @graph.send(:workers_available?), true
        end

        it "should return false" do
            set_number_of_workers(1)
            @graph.instance_variable_set("@workers", { "bologna" => true })
            assert_equal @graph.send(:workers_available?), false
        end
    end

    describe "#step_assigned?" do
        it "should return appropiate value" do
            assert_equal @graph.send(:step_assigned?, "A"), false
            @graph.instance_variable_set("@workers", { "A" => 61 })
            assert_equal @graph.send(:step_assigned?, "A"), true
        end
    end

    describe "#remove_from_available_steps" do
        it "should remove a step from @available_steps" do
            add_step_to_graph(example_step1)
            set_initial_available_steps
            assert_equal @graph.instance_variable_get("@available_steps"), %w(C)
            @graph.send(:remove_from_available_steps, "C")
            assert_equal @graph.instance_variable_get("@available_steps"), []
        end
    end

    describe "#assign_workers" do
        it "should assign 'C' and 'D' to @workers" do
            add_step_to_graph(example_step1)
            add_step_to_graph(example_step3)
            add_step_to_graph(example_step4)
            set_initial_available_steps
            set_number_of_workers(2)

            assert_equal @graph.instance_variable_get("@available_steps"), %w(C D G)
            @graph.send(:assign_workers, %w(C D G))
            assert_equal get_worker_step("C"), true
            assert_equal get_worker_step("D"), true
            assert_equal get_worker_step("G"), false

            assert_equal @graph.instance_variable_get("@available_steps"), %w(C D G)
        end
    end

    describe "#minimum_worker_time" do
        it "should return 1" do
            mock_available_steps(%w(A B C))
            set_number_of_workers(3)
            mock_time_table
            assign_workers(%w(A B C))
            assert_equal @graph.send(:minimum_worker_time), 1
        end
    end

    describe "#elapse_worker_time" do
        it "should set counter to 1" do
            assert_equal @graph.instance_variable_get("@counter"), 0
            mock_available_steps(%w(A B C))
            set_number_of_workers(2)
            mock_time_table
            assign_workers(%w(A B))

            assert_equal elapse_worker_time(1), 1
            assert_equal get_worker_value("A"), 0
            assert_equal get_worker_value("B"), 1
            assert_nil get_worker_value("C") # should never be assigned a value since no worker is on it
        end
    end

    describe "#finish_worker_tasks" do
        it "should remove workers and set @completed_steps/@available_steps" do
            add_step_to_graph(example_step1)
            set_number_of_workers(3)
            mock_time_table
            set_initial_available_steps
            assign_workers(%w(C))
            elapse_worker_time(3)
            @graph.send(:finish_worker_tasks)

            assert_equal @graph.instance_variable_get("@completed_steps"), %w(C)
            assert_equal @graph.instance_variable_get("@available_steps"), %w(A)
            assert_equal @graph.instance_variable_get("@workers"), {}
        end
    end

    describe "#parallel_traverse" do
        it "should return 15" do
            assert_equal @graph.parallel_traverse(2, 0), 15
        end
    end


    # Note: What a mess! However, I'd rather check if my functions
    # are behaving correctly than what state the object is in.
    # But this approach did cause me to set state before checking the functions!
    def mock_available_steps(steps)
        @graph.instance_variable_set("@available_steps", steps)
    end

    def elapse_worker_time(time)
        @graph.send(:elapse_worker_time, time)
    end

    def assign_workers(steps)
        @graph.send(:assign_workers, steps)
    end

    def mock_time_table
        @graph.instance_variable_set("@time_table", @graph.send(:build_time_table, 0))
    end

    def add_step_to_graph(step)
        @graph.send(:add_step_to_graph, step)
    end

    def get_worker_value(step)
        @graph.instance_variable_get("@workers")[step]
    end

    def get_worker_step(step)
        @graph.instance_variable_get("@workers")[step].is_a? Numeric
    end

    def set_initial_available_steps
        @graph.send(:set_initial_available_steps)
    end

    def set_number_of_workers(number_of_workers)
        @graph.instance_variable_set("@number_of_workers", number_of_workers)
    end
end
