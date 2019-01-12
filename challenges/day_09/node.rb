require 'byebug'

class Node
    public
    attr_accessor :value, :prev, :next

    def initialize(value)
        @value = value
        @next = self
        @prev = self
    end
end
