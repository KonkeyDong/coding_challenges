require 'byebug'
require 'pp'
require_relative '../base'

class Pots < Base
    attr_reader :patterns, :zero_index, :pots, :filled_pots

    def initialize(file)
        super(file)

        @patterns = {}
        @pots = []
        @temp_pots = []
        @zero_index = 0

        file_handle = open
            # initial state
            state = file_handle.readline.chomp
            data = parse_initial_state(state)
            expand_pots(data.split(''))
            sample = %w(. . . . . . . . . . . . . . . . . . . . .)
            @pots = sample + @pots
            @zero_index += sample.length
            @temp_pots = @pots.dup

            file_handle.readline # empty line

            # patterns
            file_handle.readlines.each do |line|
                key, value = line.chomp.split(' => ')
                @patterns[key] = value
            end
        file_handle.close
    end

    def generate(generation_limit)
        (0...generation_limit).each do |i|
            length = @pots.length
            (2..(length - 2)).each do |index|
                pot_state = find_pattern(index)
                @temp_pots[index] = pot_state if pot_state
            end

            @pots = @temp_pots.dup
            expand_pots(@pots) if expand_pots?
        end

        # pp @counts
    end

    def count_plants
        total = 0
        (0...@pots.length).each do |index|
            if index < @zero_index
                total += (@zero_index - index) if @pots[index] == "#"
            else
                total += (index - @zero_index) if @pots[index] == "#"
            end
        end

        @filled_pots = @pots.to_s.count("#")

        total
    end

    private

    # data must be an array
    def expand_pots(data)
        sample = %w(. . . . . . . . . . . . . . . . . . . . .)
        # @zero_index += sample.length
        @pots = data + sample
        @temp_pots = @pots.dup
    end

    def expand_pots?
        return true if @pots[0,5].include?("#")
        return true if @pots[-5, 5].include?("#")
        false
    end

    def find_pattern(index)
        pattern_string = @pots[index - 2, 5].join('')
        @patterns[pattern_string]
    end

    def parse_initial_state(line)
        /^initial state: ([#\.]+)$/.match(line)[1]        
    end

end
