require 'byebug'
require_relative '../base'

class Graph < Base
    def initialize(file)
        super(file)
        reset_class_variables
    end

    def traverse
        read_file

        while(!@available_steps.empty?)
            @available_steps.sort.map do |step|
                complete_step(step) if can_complete_step?(step)
                add_available_steps(step)
                if can_complete_step?(step) # restart the loop from the beginning since we're looping over an array copy
                    break
                end
            end
        end

        @completed_steps.join('')
    end

    def parallel_traverse
        read_file


    end

    private

    def reset_class_variables
        @graph = {}
        @completed_steps = []
        @available_steps = []
        @time_table = build_time_table
        @workers = []
    end

    def read_file
        reset_class_variables
        file_handle = open
        file_handle.readlines.each do |step|
            step.chomp!
            add_step_to_graph(step)
        end
        file_handle.close

        set_initial_available_steps(find_no_prev_nodes)
    end

    def build_time_table
        ('A'..'Z').zip(1..26)
                  .map { |key, value| [key, value + 60] }
                  .to_h
    end

    def find_no_prev_nodes
        @graph.keys.select { |key, _| key if @graph[key][:prev] == {} }
    end

    def set_initial_available_steps(steps)
        @available_steps += steps
        @available_steps.sort!
    end

    def complete_step(step)
        @completed_steps.push(step)
        @available_steps.delete_at(@available_steps.index(step))
        get_next_steps(step).each do |next_step|
            remove_prerequisites(next_step, step)
        end
    end

    def remove_prerequisites(step, prev_step)
        @graph[step][:prev].reject! { |key, _| key == prev_step }
    end

    def can_complete_step?(step)
        step_result = @graph&.dig(step, :prev)
        return true if step_result == {} || step_result.nil?
        false
    end

    def get_next_steps(step)
        @graph[step][:next].keys
    end

    def add_available_steps(step)
        get_next_steps(step).each { |next_step| @available_steps.push(next_step) if can_complete_step?(step) }

        @available_steps.uniq!
    end

    def add_step_to_graph(step)
        data = parse_step(step)
        add_next(*data)
        add_prev(*data)
    end

    def add_next(start, final)
        add_connection(start, final, :next)
    end

    def add_prev(start, final)
        add_connection(final, start, :prev)
    end

    def add_connection(start, final, link)
        default_tree(start)
        @graph[start][link] = @graph[start][link].merge(final => true)
    end

    def default_tree(key)
        @graph[key] ||= { next: {}, prev: {} }
    end

    def parse_step(step)
        start = parse_start(step)
        final = parse_final(step)
        [start, final]
    end

    def parse_start(step)
        /^Step (.)/.match(step)[1]
    end

    def parse_final(step)
        /(.) can begin\.$/.match(step)[1]
    end
end
