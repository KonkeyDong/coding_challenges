require_relative 'tries'

class Checksum
    def initialize(file)
        raise StandardError "File #{file} does not exist." unless File.exist?(file)
        @file = file
        @twos = 0
        @threes = 0
        @strings = []
    end

    def calculate
        file_handle = File.open(@file, 'r')
        file_handle.each_line do |line|
            line.chomp!
            occurences = count_occurences(line)
            @twos += 1 if occurences.include?(2)
            @threes += 1 if occurences.include?(3)
        end
        file_handle.close

        @twos * @threes
    end

    def different_ids
        file_handle = File.open(@file, 'r')
        file_handle.each_line do |line|
            line.chomp!
            result = Tries.find(line)
            return result if result
            Tries.add(line)
        end
        file_handle.close
    end

    private 

    def count_occurences(line)
        line.split('')
            .reduce(Hash.new(0)) do |temp_hash, key|
                temp_hash[key] += 1
                temp_hash
            end
            .select { |_, value| value == 2 || value == 3 }
            .values
    end
end
