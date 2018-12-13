require 'byebug'
require_relative '../base'

class Graph < Base
    def initialize(file)
        super(file)
        @graph = {}
        @completed_steps = []
        @available_steps = []
        @first_step = ''
    end

    private

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
