require_relative '../base'
require 'byebug'

class Claim < Base
    def initialize(file)
        super(file)
        @claims = {}
        @fabric = Hash.new(0)
        @id_dimensions = Hash.new([])
    end

    def scan
        cache_data
    end

    def find_overlap
        @fabric.select { |_, value| value > 1 }.size
    end

    def id_of_no_overlap
        @id_dimensions.each_pair do |id, list|
            overlap = false
            list.each do |dimension|
                if @fabric[dimension] > 1
                    overlap = true
                    break
                end
            end

            return id unless overlap;
        end

        return false
    end

    private

    def cache_data
        file_handle = open
        file_handle.each_line do |claim|
            claim.chomp!
            value = parse_claim(claim)
            add_claim(value)
            add_fabric(value)
        end
        file_handle.close
    end

    def parse_claim(claim)
        data = claim.split(' ')
        value = {
            id: data[0],
            start_position: %i(x y).zip(data[2].chomp(':')
                                      .split(',')
                                      .map { |element| element.to_i })
                          .to_h,
            dimensions: %i(x y).zip(data[3].split('x')
                                           .map { |element| element.to_i })
                              .to_h
        }
        
    end

    def add_claim(data)
        @claims[data[:id]] = data.reject { |key, _| key == :id }
    end

    def add_fabric(data)
        p_x = data[:start_position][:x]
        p_y = data[:start_position][:y]
        dimensions = data[:dimensions]
        list = []
        dimensions[:y].times do |i|
            dimensions[:x].times do |j|
                key = "#{p_x + j},#{p_y + i}"
                @fabric[key] += 1
                list.push(key)
            end
        end

        @id_dimensions[data[:id]] = list
    end
end
