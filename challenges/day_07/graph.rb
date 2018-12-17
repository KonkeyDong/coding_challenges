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

                 # restart the loop from the beginning since we're
                 # looping over an array copy
                break if can_complete_step?(step)
            end
        end

        @completed_steps.join('')
    end

    def parallel_traverse(number_of_workers = 5, time_base = 60)
        read_file

        @number_of_workers = number_of_workers
        @time_table = build_time_table(time_base)
        while(!@available_steps.empty?) do
            steps = @available_steps.sort
            assign_workers(steps)
            elapse_worker_time(minimum_worker_time)
            finish_worker_tasks
        end

        @counter
    end

    private

    def finish_worker_tasks
        @workers.select { |worker, value| value.zero? }
                .to_a
                .map do |element| # [0] = step; [1] = value/time
                    complete_step(element[0])
                    add_available_steps(element[0])
                end

        @workers.reject! { |key, _| @workers[key].zero? }
    end

    def elapse_worker_time(time)
        @workers.keys.map { |step| @workers[step] -= time }
        @counter += time
    end

    def assign_workers(steps)
        steps.map do |step|
            return unless workers_available?
            next unless can_complete_step?(step)
            @workers.merge!(step => @time_table[step]) unless step_assigned?(step)
        end
    end

    def minimum_worker_time
        key = @workers.keys.min_by { |key| @workers[key] }
        @workers[key]
    end

    def step_assigned?(step)
        return true if @workers[step]
        false
    end

    def workers_available?
        return true if @workers.size < @number_of_workers
        false
    end

    def reset_class_variables
        @graph = {}
        @completed_steps = []
        @available_steps = []
        @time_table = build_time_table
        @workers = {}
        @number_of_workers = 0
        @counter = 0
    end

    def read_file
        reset_class_variables
        file_handle = open
        file_handle.readlines.each do |step|
            step.chomp!
            add_step_to_graph(step)
        end
        file_handle.close

        set_initial_available_steps
    end

    def build_time_table(base_amount = 60)
        ('A'..'Z').zip(1..26)
                  .map { |key, value| [key, value + base_amount] }
                  .to_h
    end

    def find_no_previous_nodes
        @graph.keys.select { |key, _| key if @graph[key][:prev] == {} }
    end

    def set_initial_available_steps
        @available_steps += find_no_previous_nodes
    end

    def complete_step(step)
        @completed_steps.push(step)
        remove_from_available_steps(step)
        get_next_steps(step).each { |next_step| remove_prerequisites(next_step, step) }
    end

    def remove_from_available_steps(step)
        @available_steps.delete_at(@available_steps.index(step))
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
        default_node(start)
        @graph[start][link] = @graph[start][link].merge(final => true)
    end

    def default_node(key)
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
