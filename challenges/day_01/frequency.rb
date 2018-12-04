class Frequency
    def initialize(file)
        raise StandardError "File #{file} does not exist!" unless File.exist?(file)
        @file = file
    end

    def find_result
        # maybe use a more functional approach?
        # I'd rather use an iterator instead of 
        # globbing the entire file into memory.
        result = 0 
        file_handle = open
        file_handle.each_line do |line|
            result = result + line.to_i
        end
        file_handle.close

        result
    end

    def find_first_duplication
        values = { 0 => true }

        result = 0
        while true do
            file_handle = open
            file_handle.each_line do |line|
                value = line.to_i
                result = result + value
                return result if values[result]
                values[result] = true
            end
            file_handle.close
        end
    end

    private 

    def open
        File.open(@file, 'r')
    end
end
