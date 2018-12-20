
class Node
    attr_accessor :number_of_children, :metadata_amount, :children, :metadata, :root_value

    def initialize(number_of_children, metadata_amount)
        @number_of_children = number_of_children
        @metadata_amount = metadata_amount
        @children = []
        @metadata = []
        @root_value = nil
    end

    def add_metadata(number)
        @metadata.push(number)
        error("Metadata exceeded array limit. Aborting...") if @metadata.size > @metadata_amount
    end

    def add_child(node)
        @children.push(node)
        error("Metadata exceeded array limit. Aborting...") if @children.size > @number_of_children
    end

    def add_root_value(node)
        return 0 if node.nil?
        # TODO: add caching
        return node.metadata.sum unless has_children?(node)

        sum = 0
        node.metadata.each do |index|
            next if out_of_range?(node, index)
            
            index -= 1 # adjust index to zero base
            sum += add_root_value(node.children[index])
        end
        sum
    end

    private

    def out_of_range?(node, index)
        return true if index > node.children.size
        false
    end

    def has_children?(node)
        node.children.size > 0
    end

    def error(message)
        STDERR.puts message
        STDERR.puts "DUMPING OBJECT: #{self.inspect}"
        exit 1
    end
end
