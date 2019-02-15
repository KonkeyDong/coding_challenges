require 'minitest/autorun'
require 'byebug'
require_relative '../fuel_cell'

describe FuelCell do
    before do
        @fuel_cell = FuelCell.new
    end

    describe "#rack_id" do
        it "Should return number + 10... I've lost control of my life" do
            assert_equal @fuel_cell.send(:rack_id, 5), 15
        end
    end

    describe "#get_hundreds_digit" do
        it "should return 3 with 12345 as input" do
            assert_equal @fuel_cell.send(:get_hundreds_digit, 12345), 3
        end

        it "should return 0 if no hundreds digit provided" do
            assert_equal @fuel_cell.send(:get_hundreds_digit, 99), 0
        end
    end

    describe "#calculate_power_level" do
        it "should return appropiate values if @serial_number is an 8" do
            @fuel_cell.instance_variable_set("@serial_number", 8)
            assert_equal calculate(3, 5, 8), 4
            assert_equal calculate(122, 79, 57), -5
            assert_equal calculate(217, 196, 39), 0
            assert_equal calculate(101, 153, 71), 4
        end

        def calculate(x, y, serial_number)
            @fuel_cell.instance_variable_set("@serial_number", serial_number)
            @fuel_cell.send(:calculate_power_level, x, y)
        end
    end

    describe "#calculate_top_left_value" do
        let(:example_array) {
            [
                [0, 0, 0, 0],
                [0, 4, 4, 4],
                [0, 3, 3, 4],
                [0, 1, 2, 4]
            ]
        }

        it "should return 29" do
            # @fuel_cell.instance_variable_set("@grid", example_array)
            @fuel_cell.instance_variable_set("@grid", @grid = Array.new(4) { Array.new(4, 0) })
            @fuel_cell.instance_variable_set("@serial_number", 18)
            @fuel_cell.send(:find_highest_power_level)
            byebug
            assert_equal @fuel_cell.instance_variable_get("@highest_power_level") , 29
        end
    end
end