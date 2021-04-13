# Implement function ToLowerCase() that has a string parameter str, and returns the same string in lowercase.

 

# Example 1:

# Input: "Hello"
# Output: "hello"
# Example 2:

# Input: "here"
# Output: "here"
# Example 3:

# Input: "LOVELY"
# Output: "lovely"

# ------

# @param {String} str
# @return {String}
def to_lower_case(str)
    str.downcase # wise-ass solution
end

# alternatively....
def to_lower_case(str)
    result = ""
    str.chars.each do |char|
        char = (char.ord + 32).chr if char.ord >= 65 && char.ord <= 90

        result += char
    end

    result
end
