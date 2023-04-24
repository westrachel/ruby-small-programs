# Problem:
# Create a class that represents series objects and
#  has an instance method that will create all unique
#  sequences of a specified length for the string number
#  that's assigned to an instance variable upon instantiation

# Requirements:
#  > the instance method should be called slices and expects
#     1 argument, a positive integer, that should specify
#     the length of the unique series returned and should return
#     all possible unique series in subarrays
#      > if pass in a positive number that's longer than the
#         number of elements in the string that the instance
#         variable points to then an ArgumentError should be
#         raised
#      > the subarrays returned should contain integers, whereas
#          the instance variable will point to a string that
#          represents a number
#      > all the unique series should be consecutive, and should not
#        be shuffled/representative of all unique possible combos of
#        the numbers within
#           > this is based on looking at test cases, for ex:
#              say @num is set to point to "01234" & slice(3) is invoked
#              expected return value = [[0, 1, 2], [1, 2, 3], [2, 3, 4]]
#              <=> [4, 3, 2] is not included in the returned array
#     > the return value states all possible sub-sequences, which it's possible
#        that 2 sub-sequences could be the same, I will assume that I should
#        return all unique sub-sequences

# Algorithm for slices instance method:
# i. raise an ArgumentError if the argument passed in is too large
#     > the argument is too large of the numerical value the @num
#         instance variable points to is smaller than the integer argument
# ii. initialize an empty return array that will hold all the unique subsequences
# iii. iterate over the string and on each iteration select a slice of the 
#       string whose length corresponds with the integer argument
#         > can use the #times method to keep track of the starting index to
#             begin the slice at
#              > stop iterating when the starting index to start a slice at is
#                  greater than the value returned from subtracting the integer
#                  argument from the size of the string that the @num instance variable
#                  points to
#              > actually, instead of breaking execution, if I'm using the times method, then
#                 I can just alter the number that the times method is called on to require
#                 fewer iterations
#         > split each string slice, so that an array is returned containing
#             string characters
#         > use map to transform the returned sliced array, so that each character
#            string in the sliced array is converted to an integer
#         > push the mapped sliced array to the overall return array that was previously
#            created under step ii. to store all the unique sequences


class Series
  attr_reader :num
  def initialize(num)
    @num = num
  end

  def slices(integer)
    raise ArgumentError if integer > num.size
    sub_sequences = []
    (num.size - integer + 1).times do |index|
      sub_sequences << transform(num[index, integer])
    end
    sub_sequences.uniq
  end

  def transform(substring)
    substring.split('').map { |char| char.to_i }
  end
end
