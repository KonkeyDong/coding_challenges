
class Node
    attr_accessor :number_of_children, :metadata_amount, :children, :metadata

    def initialize(number_of_children, metadata_amount)
        @number_of_children = number_of_children
        @metadata_amount = metadata_amount
        @children = []
        @metadata = []
    end

    def add_metadata(number)
        @metadata.push(number)
        error("Metadata exceeded array limit. Aborting...") if @metadata.size > @metadata_amount
    end

    def add_child(node)
        @children.push(node)
        error("Metadata exceeded array limit. Aborting...") if @children.size > @number_of_children
    end

    private

    def error(message)
        STDERR.puts message
        STDERR.puts "DUMPING OBJECT: #{self.inspect}"
        exit 1
    end
end
