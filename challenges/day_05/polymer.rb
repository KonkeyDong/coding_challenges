require_relative '../base'
require 'byebug'

class Polymer < Base
    def initialize(file)
        super(file)
        reset_stack
    end

    def scan
        file_handle = File.new(@file)
        while(char = file_handle.getc())
            stack_operation(char)
        end
        file_handle.close
    end

    def size
        @stack.size
    end

    # This probably isn't the most efficient method,
    # but don't you have to remove all of a certain character
    # each time on the input? Perhaps I could speed this up
    # by running the input through a hash and keeping tally of
    # all characters and then just checking for those characters only.

    # So, what I'm saying is, if we don't have a 'Z' in the input,
    # I'm scanning through the data completely and that would be a waste
    # since it would be similar to just running the #scan method!

    # But the example the site gives implies that you have to remove
    # the characters each time. I'm rolling with it.
    def scan_without_polymer
        data = {}
        ('a'..'z').each do |target_char|
            reset_stack
            file_handle = File.new(@file)
            while(char = file_handle.getc())
                next if char.casecmp?(target_char)
                stack_operation(char)
            end
            file_handle.close
            data[target_char] = size
        end

        key = data.keys.min_by { |key| data[key] }
        data[key]
    end

    private

    def reset_stack
        @stack = []
    end

    def stack_operation(char)
        if reacts?(char)
            @stack.pop if reacts?(char)
        else
            @stack.push(char)
        end
    end

    def reacts?(char)
        return false if @stack.empty?
        @stack.last == char.swapcase
    end
end
