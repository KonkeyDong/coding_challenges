require_relative 'graph'

graph = Graph.new("challenge.txt")
graph.initialize_graph
puts "Number of seconds: #{graph.find_message}"
graph.print_message