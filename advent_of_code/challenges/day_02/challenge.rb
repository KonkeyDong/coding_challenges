require_relative 'checksum'
require_relative 'tries'

checksum = Checksum.new('challenge.txt')
checksum_value = checksum.calculate
difference = checksum.different_ids

puts "checksum = #{checksum_value}"
puts "difference: #{difference}"
