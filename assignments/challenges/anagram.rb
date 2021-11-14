# Problem:
# Create an anagram class that can detect and select from a list
#   of words all the words that are anagrams of the instance variable
#   initialized upon instantiation of an anagram isntance.

# Anagram requirements:
#  > anagrams have the same number and types of letters but are
#      ordered different
#  > case sensitivity doesn't apply in finding unique anagrams
#     <=> specifically, if corn is the word that anagrams are being
#      found for, then Corn would not be considered an anagram b/c
#      it has the same letters in the same order as corn
#  > may need to find anagrams for a word that has capital letters,
#     so mechanism that checks for valid anagrams needs to be able
#     to assess that letters are equivalent even if they have different
#     case

# To make the test cases work for the Anagram class need to:
#   > define the initialize method to establish a word instance
#      variable that will be used by instance methods to find anagrams
#   > define an instance variable that points to an array that will
#      store anagram words
#   > define a match method that accepts an array argument of words and that
#      selects all words that are anagrams of the @word instance variable
#       > the match method's return value should be an array of the anagram
#          words

class Anagram
  attr_reader :word
  attr_accessor :anagrams

  def initialize(word)
    @word = word
    @anagrams = []
  end

  def match(words_arr)
    word1 = word.downcase
    valid_anagrams = words_arr.select do |word2|
      word2 = word2.downcase
      word2 != word1 &&
      word1.chars.sort.join('') == word2.chars.sort.join('')
    end
    valid_anagrams.each { |word| self.anagrams << word }
  end
  
    
end