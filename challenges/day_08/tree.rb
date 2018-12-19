require 'byebug'
require_relative 'node'
require_relative '../base'

class Tree < Base
    attr_reader :root

    def initialize(file)
        super(file)
        @root = nil

        file_handle = open
            line = file_handle.readline.chomp
            @data = line.split(' ')
        file_handle.close
    end

    def build
        @root = build_tree
        nil
    end

    def sum_metadata(node = @root)
        sum = 0
        node.children.each { |child| sum += sum_metadata(child) }
        sum += node.metadata.sum
    end

    def sum_root
        @root.each
    end

    private

    def build_tree
        number_of_nodes = next_number
        metadata_amount = next_number

        node = Node.new(number_of_nodes, metadata_amount)
        number_of_nodes.times { |_| node.add_child(build_tree) }
        metadata_amount.times { |metadata| node.add_metadata(next_number) }

        node
    end

    def next_number
        @data.shift.to_i
    end
end
