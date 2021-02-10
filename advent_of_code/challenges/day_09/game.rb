require 'byebug'
require_relative 'linked_list'

class Game
    def initialize(number_of_players, last_marble_value)
        @number_of_players = number_of_players
        @last_marble_value = last_marble_value
        @scores = Array.new(@number_of_players + 1, 0)
    end

    def play
        ll = LinkedList.new(0)

        # Ruby is still a bit slow for the second part involving
        # circular double-linked lists (about 6 seconds), but I'll
        # take that over waiting 5 minutes and not getting an answer
        # with re-shuffling arrays around.
        (1..@last_marble_value).each do |marble|
            if multiple_of_23?(marble)
                value = ll.remove
                @scores[player_offset(marble)] += marble + value
            else
                ll.add(marble)
            end
        end

        max_score = @scores.max
        index = @scores.index(max_score)
        [index, max_score]
    end

    def player_offset(index)
        offset = (index % @number_of_players)
        if offset == 0
            return @number_of_players
        end
        offset
    end

    def multiple_of_23?(marble)
        return false if marble.zero?
        return marble % 23 == 0
    end
end
