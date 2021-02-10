require 'byebug'
require 'pp'
require_relative '../base'
require_relative 'point'

class Graph < Base
    attr_reader :number_of_points, :graph

    def initialize(file)
        super(file)

        @bounding_box = 9999999999999999 # < Graham's Number!
        @number_of_points = 0
        @graph = []
    end

    def initialize_graph
        file_handle = open

        file_handle.each do |line|
            line.chomp!
            data = parse_line(line)
            point = Point.new(data)

            @graph.push(point)
            @number_of_points += 1
        end
        file_handle.close
    end

    def find_message
        iterations = 0
        while(true)
            box_size = calculate_bounding_box
            if @bounding_box > box_size
                @graph.each {|point| point.move_point }
                iterations += 1
                @bounding_box = box_size
            else
                @graph.each {|point| point.revert_point }
                break
            end
        end
    
        iterations - 1
    end

    def print_message
        x_min, x_max = find_minmax(:x)
        y_min, y_max = find_minmax(:y)

        shift_to_positive_quadrant(x_min, y_min)

        number_of_rows = x_max + x_min.abs
        number_of_columns = y_max + y_min.abs + 3
        grid = Array.new(number_of_rows + 1) {Array.new(number_of_columns + 2, ".")}

        # notice that the x and y variables are switched when placing '#' into the grid.
        @graph.each do |point|
            x = point.position[:x] + 1
            y = point.position[:y] + 1
            grid[y][x] = "#"
        end

        # Write output. Probably best to just write the message area, but I hated this problem.
        file_name = "challenge_01.txt"
        File.open(file_name, 'w') do |file| 
            grid.each do |line|
                file.write("#{line}\n")
            end
        end
        puts "Please open [#{file_name}] to view the message. You'll want a text editor that can scroll!"

        nil
    end

    def calculate_bounding_box
        x_min, x_max = find_minmax(:x)
        y_min, y_max = find_minmax(:y)

        (x_max - x_min) * (y_max - y_min)
    end

    private

    def shift_to_positive_quadrant(x, y)
        @graph.each {|point| point.position[:x] += x.abs } if x < 0 # right
        @graph.each {|point| point.position[:y] += y.abs } if y < 0 # down
    end

    def find_minmax(direction)
        min, max = @graph.minmax {|a, b| a.position[direction] <=> b.position[direction] }
        [min.position[direction], max.position[direction]]
    end

    def parse_line(line)
        position = parse_position(line)
        velocity = parse_velocity(line)
        {
            position: position,
            velocity: velocity
        }
    end

    def parse_position(line)
        positions = /^position=<(.+)> velocity/.match(line)[1].split(', ')
        separate_values(positions)
    end

    def parse_velocity(line)
        velocities = /velocity=<(.+)>$/.match(line)[1].split(', ')
        separate_values(velocities)
    end

    def separate_values(values)
        {
            x: values[0].to_i,
            y: values[1].to_i
        }
    end
end
