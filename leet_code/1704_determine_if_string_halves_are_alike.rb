# You are given a string s of even length. Split this string into two halves of equal lengths, and let a be the first half and b be the second half.

# Two strings are alike if they have the same number of vowels ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'). Notice that s contains uppercase and lowercase letters.

# Return true if a and b are alike. Otherwise, return false.

 

# Example 1:

# Input: s = "book"
# Output: true
# Explanation: a = "bo" and b = "ok". a has 1 vowel and b has 1 vowel. Therefore, they are alike.
# Example 2:

# Input: s = "textbook"
# Output: false
# Explanation: a = "text" and b = "book". a has 1 vowel whereas b has 2. Therefore, they are not alike.
# Notice that the vowel o is counted twice.
# Example 3:

# Input: s = "MerryChristmas"
# Output: false
# Example 4:

# Input: s = "AbCdEfGh"
# Output: true
 

# Constraints:

# 2 <= s.length <= 1000
# s.length is even.
# s consists of uppercase and lowercase letters.

# -----------

CHAR_MAP = {
    'a' => 0,
    'e' => 0,
    'i' => 0,
    'o' => 0,
    'u' => 0,

    'A' => 0,
    'E' => 0,
    'I' => 0,
    'O' => 0,
    'U' => 0
}

# @param {String} s
# @return {Boolean}
def halves_are_alike(s)
    a = s.slice(0, s.length / 2)
    b = s.slice(s.length / 2, s.length)

    vowel_count = 0

    a.chars.each { |char| vowel_count += 1 if CHAR_MAP[char] }
    b.chars.each { |char| vowel_count -= 1 if CHAR_MAP[char] }

    vowel_count == 0
end

# other ways to solve this:
def halves_are_alike
    a = s[0...s.size / 2].downcase
    b = s[s.size / 2...s.size].downcase

    a.scan(/[aiueo]/).count == b.scan(/[aiueo]/).count
end

# another alternative:
def nv(s)
    s.delete('^AEIOUaeiou').size
end

def halves_are_alike(s)
    n = s.size / 2
    
    nv(s[0..n - 1]) == nv(s[-n..-1])
        
end