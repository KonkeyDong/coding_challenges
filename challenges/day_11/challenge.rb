require_relative 'fuel_cell'

fuel_cell = FuelCell.new
value = fuel_cell.find_highest_power_level(3)
puts "Highest power level is at: #{value}"

shitty_value = fuel_cell.find_highest_power_level
puts "Highest power level is at: #{shitty_value}"