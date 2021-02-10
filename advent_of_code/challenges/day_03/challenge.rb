require_relative 'claim'

claim = Claim.new('challenge.txt')
claim.scan

puts "overlap: #{claim.find_overlap}"
puts "id: #{claim.id_of_no_overlap}"
