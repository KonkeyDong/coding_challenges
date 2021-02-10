require_relative 'graph'

graph = Graph.new("challenge.txt")

puts "step sequence: #{graph.traverse}"
puts "time: #{graph.parallel_traverse}"