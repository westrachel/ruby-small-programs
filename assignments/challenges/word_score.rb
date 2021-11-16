# Problem:
# Create a class whose instances represent valid scrabble words.
#   When instantiated, the object's word should be passed in as
#   an argument. The #score public instance method should return
#   the corresponding score of the word.

# Requirements:
#  i. The returned score should reflect the base score of the word
#      and should not reflect triple letter/double word scores.
#  ii. Words passed in can be all uppercased or lowercased
#  iii. Return a score of zero if the word passed in is nil, empty, or
#        has trailing whitespaces/new lines
#       >> for trailing whitespace/new line cases, need to check if the word
#           includes those cases, which can be done using #match which will
#           return nil if the specificed characters being tested are not
#           present
          ("\t\n").match(/\s/) # => #<MatchData "\t"> 
          #  return value of the above will evaluate as truthy, and can be included
          #   in an #invalid_word? instance method to ensure the intended zero score
          #   is returned
  
#  iv. Need to define a class method that will score a passed in addition
#       to an instance score method

LETTER_POINTS = {}

ABCS = ("a".."z").to_a

# Fill in the LETTER_POINTS constant with each letter + its corresponding
#   point value as a key/value pair
ABCS.each do |letter|
  points = if %w(a e i o u l n r s t).include?(letter)
             1
           elsif %w(d g).include?(letter)
             2
           elsif %w(b c m p).include?(letter)
             3
           elsif %w(f h v w y).include?(letter)
             4
           elsif letter == "k"
             5
           elsif %w(j x).include?(letter)
             8
           else
             10
           end
  LETTER_POINTS[letter] = points
end

class Scrabble
  attr_reader :word

  def initialize(word)
    @word = word
  end

  def self.score(a_word)
    Scrabble.new(a_word).score
  end

  def score
    score = 0
    return score if invalid_word?
    word.chars.map do |letter|
      score += LETTER_POINTS[letter.downcase]
    end
    score
  end

  def invalid_word?
    word.nil? || word.empty? || word.match(/\s/)
  end

end