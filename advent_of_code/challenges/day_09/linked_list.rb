require 'byebug'
require_relative 'node'

class LinkedList
    attr_reader :root, :amount

    def initialize(value)
        @root = Node.new(value)
        @first = @root
        @amount = 1
    end

    def rotate(number)
        return if number.zero?

        node = @root
        if number.positive?
            while number > 0 do
                node = node.next
                number -= 1
            end
        else
            while number < 0 do
                node = node.prev
                number += 1
            end
        end

        @root = node
    end

    def remove(number_of_nodes = -7)
        rotate(number_of_nodes)

        # store the pointer for deletion later
        ptr = @root

        @root.prev.next = @root.next
        @root.next.prev = @root.prev

        @root = @root.next

        @amount -= 1
        value = ptr.value

        # cleanup, but may not be needed
        ptr = nil
        value
    end

    def add(value, number_of_nodes = 1)
        new_node = Node.new(value)

        if @amount == 1
            @root.next = new_node
            @root.prev = new_node

            new_node.next = @root
            new_node.prev = @root
        else # ick
            ptr = @root
            rotate(number_of_nodes)

            new_node.next = @root.next
            new_node.prev = @root

            new_node.next.prev = new_node

            @root.prev = ptr
            @root.next = new_node
        end

        @amount += 1
        @root = new_node
    end

    def print_list_next
        print_list(:next)
    end

    def print_list_prev
        print_list(:prev)
    end

    private

    def print_list(direction)
        a = []
        ptr = @first
        @amount.times do |i|
            a.push(ptr.value)
            ptr = ptr.send(direction)
        end

        result = a.join('')
        # puts # new line
        # puts "#{direction.to_s}: #{result}"
        result
    end
end
