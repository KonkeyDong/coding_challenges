# Given an array of integers nums.

# A pair (i,j) is called good if nums[i] == nums[j] and i < j.

# Return the number of good pairs.

# Example 1:

# Input: nums = [1,2,3,1,1,3]
# Output: 4
# Explanation: There are 4 good pairs (0,3), (0,4), (3,4), (2,5) 0-indexed.
# Example 2:

# Input: nums = [1,1,1,1]
# Output: 6
# Explanation: Each pair in the array are good.
# Example 3:

# Input: nums = [1,2,3]
# Output: 0
 

# Constraints:

# 1 <= nums.length <= 100
# 1 <= nums[i] <= 100

# This solution I purloined from the submission tab as this goes throug
# the array once [O(n)] compared to [O(n^2)]. I'll still post my original solution

# solution 1: O(n^2)
def num_identical_pairs(nums)
    nums.each_with_index.reduce(0) do |pairs, (_, i)|
        (i+1...nums.length).each do |j|
            pairs += 1 if nums[i] == nums[j] && i < j
        end
        
        pairs
    end
end


# solution 2: O(n)
# @param {Integer[]} nums
# @return {Integer}
def num_identical_pairs(nums)
    nums.each_with_object({}) do |num, cache|
       if cache[num]
           cache[num] << (cache[num][-1] + 1)
       else
           cache[num] = [0]
       end
    end.values.map(&:sum).sum
 end

