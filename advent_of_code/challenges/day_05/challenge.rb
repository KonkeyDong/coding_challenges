require_relative 'polymer'

polymer = Polymer.new('challenge.txt')
polymer.scan

puts "size: #{polymer.size}"
puts "smallest without polymer: #{polymer.scan_without_polymer}"