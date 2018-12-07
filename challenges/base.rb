class Base
    def initialize(file)
        raise StandardError "File #{file} does not exist!" unless File.exist?(file)
        @file = file
    end

    def open
        File.open(@file, 'r')
    end
end