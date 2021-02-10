require_relative 'frequency'

frequency = Frequency.new('challenge.txt')
puts "The answer is: #{frequency.find_result}"
puts "The first duplicate value is: #{frequency.find_first_duplication}"