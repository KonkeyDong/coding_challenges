# See this URL for pictures: https://leetcode.com/problems/minimum-cost-to-move-chips-to-the-same-position/

# @param {Integer[]} position
# @return {Integer}
def min_cost_to_move_chips(position)
    lookup = Hash.new(0)
    position.each do |p|
        lookup[p] += 1
    end
    
    [find_minimum_move(lookup, :even?), find_minimum_move(lookup, :odd?)].min
end

def find_minimum_move(lookup, method)
    result = 0
    lookup.keys
        .select(&method)
        .each do |key|
            result += lookup[key]
        end
    
    result
end
