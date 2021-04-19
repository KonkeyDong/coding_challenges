# You are given coordinates, a string that represents the coordinates of a square of the chessboard. Below is a chessboard for your reference.



# Return true if the square is white, and false if the square is black.

# The coordinate will always represent a valid chessboard square. The coordinate will always have the letter first, and the number second.

 

# Example 1:

# Input: coordinates = "a1"
# Output: false
# Explanation: From the chessboard above, the square with coordinates "a1" is black, so return false.
# Example 2:

# Input: coordinates = "h3"
# Output: true
# Explanation: From the chessboard above, the square with coordinates "h3" is white, so return true.
# Example 3:

# Input: coordinates = "c7"
# Output: false
 

# Constraints:

# coordinates.length == 2
# 'a' <= coordinates[0] <= 'h'
# '1' <= coordinates[1] <= '8'

# --------------

FIRST_ROW = [
    false,
    true,
    false,
    true,

    false,
    true,
    false,
    true
]

LETTER_MAP = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7
}

# @param {String} coordinates
# @return {Boolean}
def square_is_white(coordinates)
    letter, number = coordinates.split('')
    letter = LETTER_MAP[letter]

    number.to_i.even? ? !FIRST_ROW[letter] : FIRST_ROW[letter]
end