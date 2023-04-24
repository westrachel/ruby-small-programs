# Problem:
# Create a class that can convert an octal number to a decimal

# Input:
#    > initialize an object of the class to have an octal number
#         string attribute

# Output of to_decimal instance method:
#    > a decimal number (integer; not a float)
#    > if input is 'invalid' then output 0
#       > invalid input = string of letters

# Octal -> Decimal conversion:
# 233  <-- the octal # input
# = 2*8^2 + 3*8^1 + 3*8^0
# = 2*64 + 3*8 + 3*1


# Algorithm for to_decimal method:
# i. Return zero if the octal_number instance variable converted
#     to an integer than converted back to a string doesn't equal
#     itself than it's not a valid octal number
#       > this actually won't work b/c one of the test cases allows for a
#          '011' octal number input which would be considered invalid w/
#          the string to integer to string conversion
#       > invalids have 8s and 9s
#       > so, instead, should iterate over the character numbers of octal
#         num and check if they're included in a valid digits array
#         > if any character number isn't in the array then the octal_num
#            is invalid, and should return 0
# ii. Convert the octal number string into individual character numbers
# iii. Iterate over the individual string numbers and convert each
#        string number into an integer
# iv. Initialize a power variable that points to the size of the array
#       created from step 3 minus 1
#          > this will represent the power that 8 should be raised to
#              and then multiplied by the first integer in the array
#              created in step 3
# v. Iterate over the array in step 3 and on each iteration:
#          > multiply the integer being iterated over by the return
#             value of raising 8 to the number that the power variable
#             currently points to (*)
#          > subtract 1 from the value that the power variable points to
#          > add the value calculated in (*) step above to a running total


VALID_DIGITS = ["0", "1", "2", "3", "4", "5", "6", "7"]

class Octal
  attr_reader :octal_num
  def initialize(octal_num)
    @octal_num = octal_num
  end

  def to_decimal
    return 0 if invalid_octal?
    digits = octal_num.chars.map(&:to_i)
    power = digits.size - 1
    digits.each_with_object([]) do |num, array|
      array << num*(8 ** power)
      power -= 1
    end.sum
  end

  def invalid_octal?
    octal_num.chars.any? { |num| VALID_DIGITS.include?(num) == false }
  end
end
