require_relative 'tree'

tree = Tree.new('challenge.txt')
tree.build

puts "Sum of metadata: #{tree.sum_metadata}"
puts "Root value: #{tree.sum_root}"