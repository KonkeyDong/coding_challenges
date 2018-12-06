# This is a simple implementation of a fuzzy search to look for strings with only one difference
# I named it "Tries" after the section in Algorithms 4th Edition by Sedgewick, if anyone wondered.
# https://github.com/haseebr/competitive-programming/blob/master/Materials/Algorithhms%204th%20Edition%20by%20Robert%20Sedgewick%2C%20Kevin%20Wayne.pdf

class Tries
  @root = {}
  @cache = {}
  
  def self.add(string)
    return string if @cache[string]

    pointer = @root
    all_but_last_char(string).each_char do |char|
      pointer[char] ||= {} 
      pointer = pointer[char]
    end

    add_string_to_last_field(string, pointer)
    @cache[string] = true
  end

  # Finds a string with only one difference.
  # Returns the union between the strings
  def self.find(string)
    return false if @root.empty?
    return string if @cache[string]

    pointer = @root
    chars = string.split('')
    string.each_char do |char|
        unless pointer[char]
            result = no_other_bad_characters?(chars, pointer)
            return string_union(string, result) if result
            return false
        end

        pointer = pointer[char]
        chars = chars.drop(1)
    end
  end

  def self.clear
    @root = {}
    @cache = {}
  end

  private

  def self.string_union(string1, string2)
    chars = []
    length = string1.length <= string2.length ? string1.length : string2.length
    for i in 0..length do
        chars.push(string1[i]) if string1[i] == string2[i]
    end
    chars.join('')
  end

  def self.no_other_bad_characters?(chars, pointer)
    chars = chars.drop(1)
    root = pointer
    pointer.keys.each do |key|
        pointer = root # reset
        pointer = pointer[key] # advance one

        chars.each do |char|
            return false unless pointer[char]
            pointer = pointer[char]
        end
    end

    pointer # should be the found string
  end

  def self.all_but_last_char(string)
    string[0, string.length - 1]
  end

  def self.add_string_to_last_field(string, field)
    field[string[-1]] = string
  end
end

