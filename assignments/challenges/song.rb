# Problem:
# Create a program that will output verses or the full beer song.

# Requirements:
#  > based on test cases, should be able to pass in 2 numbers or 1 number argument
#      into the verse class method
#       > the return value of verse should be a multiline string corresponding with a verse
#           or verses of the beer song
#       > the return value of verse should be several multiline strings corresponding w/ the verses
#         that increment from the verse correspopnding w/ the first argument to the verse corresponding
#         with the second argument
#             ex: when call verse(2, 0), should return the multiline string w/ verse 2, verse 1, & verse 0
#       > if pass in the argument 3 into the verse method, then the verse that has 3 bottles in it
#            should be returned
#  > lyrics class method should return the full song as a multiline string

# Notes on verse class method:
#   > want to be able to pass in 1 or more arguments
#   > can establish multiple arguments by adding a * to the parameter in the class method definition
#   > based on testing in irb, confirmed that if define class method with a * before the parameter, then
#      it will be parsed as an array; ex:
def multiple_arguments(*nums)
  p nums
end

multiple_arguments(99, 0) # => [99, 0]
#   > for the beer song class purposes, I will want to reverse the nums array w/in the method definition
#      so that the smallest integer is first, then I will want to increment upwards from the smallest
#      integer to the largest integer and pass in each integer to the repeated_verse method definition
#      to return the desired multiline string verse
#   > need to make sure I return just an integer w/ 1 number if one argument is passed in, so will want to add in
#      a conditional

def multiple_arguments(*nums)
  if nums[1].nil?
    nums
  else
    nums[1].upto(nums[0]).to_a.reverse
  end
end

p multiple_arguments(99, 0) # => returns array whose first element == 99 and that contains integers incrementing
#   downwards to 0 as intended
p multiple_arguments(5) # => [5]    <=> confirms that method can handle when only 1 argument is passed in
      
class BeerSong
  def self.verse(num)
    repeated_verse(num)
  end

  def self.verses(*nums)
    nums[1].upto(nums[0]).to_a.reverse.each_with_object([]) do |num, verses_arr|
      verses_arr << repeated_verse(num)
    end.join("\n")
  end
    
  def self.lyrics
    self.verse(99, 0)
  end

  private
  def self.repeated_verse(number)
    self.plural_verse(number) if number == 2
    single_verse if number == 1
    no_more_verse if number == 0
    plural_verse if number > 2
  end

  def self.plural_verse(num)
    "#{num} bottles of beer on the wall, #{num} bottles of beer.\n" +
    "Take one down and pass it around, #{num - 1} bottles of beer on the wall.\n"
  end

  def self.double_verse
    "2 bottles of beer on the wall, 2 bottles of beer.\n" + 
    "Take one down and pass it around, 1 bottle of beer on the wall.\n"
  end

  def self.single_verse
    "1 bottle of beer on the wall, 1 bottle of beer.\n" +
    "Take it down and pass it around, no more bottles of beer on the wall.\n"
  end

  def self.no_more_verse
    "No more bottles of beer on the wall, no more bottles of beer.\n" + 
    "Go to the store and buy some more, 99 bottles of beer on the wall."
  end
end

p BeerSong.verse(5)