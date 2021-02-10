require 'byebug'
require 'pp'

class FuelCell
    attr_reader :power_levels, :grid

    def initialize
        @serial_number = 3628
        @grid = Array.new(301) { Array.new(301, 0) }
        @power_levels = {}
        @highest_power_level = -999999999
        @bx = 0
        @by = 0
        @bs = 0
    end

    def find_highest_power_level(max_square_size=@grid.length)
        initialize_grid
        summed_area_table
    end

    def initialize_grid
        (1...@grid.length).each do |y|
            (1...@grid.length).each do |x|
                power_level = calculate_power_level(x, y)
                @grid[y][x] = power_level + @grid[y - 1][x] + @grid[y][x - 1] - @grid[y - 1][x - 1]
            end
        end
    end

    # try using a summed-area table
    def summed_area_table(max_square_size)
        (1...max_square_size).each do |square|
            (square...@grid.length).each do |y|
                (square...@grid.length).each do |x|

                    # Some real gypsy shit here...
                    total = @grid[y][x] - @grid[y - square][x] - @grid[y][x - square] + @grid[y - square][x - square]

                    if total > @highest_power_level
                        @highest_power_level = total
                        @bx = x
                        @by = y
                        @bs = square
                    end
                end
            end
        end

        puts "#{@bx - @bs + 1},#{@by - @bs + 1},#{@bs}"
    end

    private

    def calculate_top_left_value(x, y, max_square_size)
        max_square_size = calculate_max_square_size(x, y)

        (0...3).each do |square|
            value = 0
            (y..(y+square)).each do |y_coord|
                (x..(x+square)).each do |x_coord|
                    value += @grid[y_coord][x_coord]
                end
            end
            @power_levels[value] ||= []
            @power_levels[value].push("#{x},#{y},#{square+1}")
            @highest_power_level = value if value > @highest_power_level
        end
    end

    def calculate_max_square_size(x, y)
        grid_size = @grid.length
        x_limit = grid_size - x
        y_limit = grid_size - y

        x_limit < y_limit ? x_limit : y_limit
    end

    def rack_id(x)
        x + 10
    end

    def calculate_power_level(x, y)
        temp = rack_id(x)
        temp *= y
        temp += @serial_number
        temp *= rack_id(x)
        temp = get_hundreds_digit(temp)
        temp -= 5
        temp
    end

    def get_hundreds_digit(number)
        return 0 if number < 100
        number.to_s[-3].to_i
    end
end
