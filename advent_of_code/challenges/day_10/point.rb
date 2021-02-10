require 'byebug'

class Point
    attr_reader :position, :velocity

    def initialize(**data)
        @position = data[:position]
        @velocity = data[:velocity]
    end

    def move_point
        @position[:x] += @velocity[:x]
        @position[:y] += @velocity[:y]
    end

    def revert_point
        @position[:x] -= @velocity[:x]
        @position[:y] -= @velocity[:y]
    end
end
