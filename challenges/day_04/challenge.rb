require_relative 'repose'

repose = Repose.new('challenge.txt')
repose.scan


puts "code_1: #{repose.guard_code}"
puts "code_2: #{repose.most_slept_minute}"