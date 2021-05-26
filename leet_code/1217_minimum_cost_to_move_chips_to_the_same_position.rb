# See this URL for pictures: https://leetcode.com/problems/minimum-cost-to-move-chips-to-the-same-position/

# @param {Integer[]} position
# @return {Integer}
def min_cost_to_move_chips(position)
    position.reduce({ odd: 0, even: 0 }) do |cache, num|
        key = num.odd? ? :odd : :even
        cache[key] += 1

        cache
    end.values.min
end
