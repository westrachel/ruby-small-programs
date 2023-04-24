# Problem:
# Create a class containing a class method that accepts
#  a string letter as an argument and returns a string
#  diamond

# Diamond Requirements:
# i. The diamond is outlined by capitalized letters
# ii. The diamond is symmetrical horizontally + vertically
# iii. The diamond fits into a square grid
# iv. The string letter argument represents the letter that
#      should be present at the widest part of the diamond
#    Exs:
#      > if 'A' is the argument, then the returned diamond
#          should be one line long and return the string 'A\n'
#      > if 'E' is the argument, then 'E' appears only twice
#          in the widest row of the diamond
# v. Based on test case, the width of the diamond in the
#     widest row, and should equal 2 plus the place in the
#     alphabet of the letter
#    Ex: argument = 'C', the middle/widest row of the diamond
#      has a size of 5 (excluding the newline character)
#     <=> there are 3 spaces between the 2 outer characters
#     <=> for creting an algorithm, the width is important for
#       determinng the number of spaces that should appear before a
#       letter in each diamond row

#       > for the first row of the 'C' diamond, the number
#          of spaces before the letter 'A' appears is 2
#       > the index position of the letter 'C' in the ABCS constant
#           is 2, so can establish a variable outer_num_spaces that's
#           initialized to point to the letter argument's position in
#           the ABCS array constant and then during the iterative diamond
#           line creative process can subtract 1 from the value

# make_diamond class method algorithm:
# (a) Creating the top half of the diamond:
#     i. initialize an outer_num_spaces variable that points to the index
#         position of the letter argument in the ABCS constant array
#         value of the letter argument's index
#     ii. initialize an inner_num_spaces variable that points to 1
#     iii. initialize an index variable that points to 0
#     iv. initialize a diamond lines array variable that points to an empty array
#     v. start a loop, and on each iteration:
#         > create a string that is the result of concatenating the:
#              >> outer_num_spaces's number of spaces
#              >> the letter at the index's position in the ABCS constant array
#              >> the inner_num_space's number of spaces
#              >> the letter at the index's position in the ABCS constant array
#              >> the outer_num_space's number of spaces
#              >> and a newline character
#         > push the above created string to the diamond lines array
#           Note: 
#             i. if the letter being iterated over is 'A' then ignore the inner
#                  number of spaces variable and only push to the diamond string
#             ii. if the letter being iterated over is the letter argumnet itself
#                   then ignore the outer number of spaces variable
#         > subtract 1 from the value that the outer_num_spaces variable points to
#         > add 2 to the inner_num_spaces variable as long as the current letter being
#            iterated over isn't 'A'
#         > add 1 to the integer the index variable points to
#         > break the loop once reach the letter that is one place to the right
#            of the letter argument passed in
# (b) Creating the bottom part of the diamond/overall diamond
#     vi. Slice the diamond array created in step (v) and select all the diamond
#           line elements in the array except for the last element and then reverse
#           slice so that the lines are in descending order
#     vii. Add the first half of the diamond represented by the diamond line elements in
#           the diamond array created in step (v) to the second half of the diamond 
#           represented by the diamond line elements in the diamond created in step (vi)
#     viii. combine all the elements in the overall diamond array created in step (vii) to
#            one diamond string

# Refactoring:
#  > can condense the top_part class method by initializning fewer variables
#     > slice the ABCS constant from the 0th index to the index of the letter argument of
#         the make_diamond class method invocation and then iterate over this slice
#         using the each_with_object method invocation to create a diamonds_line_array

ABCS = ('A'..'Z').to_a

class Diamond
  def self.make_diamond(letter)
    return "A\n" if letter == 'A'
    diamond_half = top_part(letter, ABCS.find_index(letter))
    diamond_arr = diamond_half + latter_part(diamond_half)
    diamond_arr.each_with_object("") { |diamond_line, str| str << diamond_line }
  end

  def self.top_part(char, outer_num_spaces)
    inner_num_spaces = 1
    diamond_lines_arr = ABCS[0..(ABCS.find_index(char))].each_with_object([]) do |letter, array|
      str = case letter
            when 'A' then ' ' * outer_num_spaces + 'A' + ' ' * outer_num_spaces + "\n"
            when char then letter + ' ' * inner_num_spaces + letter + "\n"
            else  ' ' * outer_num_spaces + letter + ' ' * inner_num_spaces + letter + ' ' * outer_num_spaces + "\n"
            end
      outer_num_spaces -= 1
      inner_num_spaces += 2 if letter != 'A'
      array << str
    end
    diamond_lines_arr
  end

  def self.latter_part(initial_diamond_half)
    initial_diamond_half[0...(initial_diamond_half.size - 1)].reverse
  end
end

# Check work before running full test suite:
string = Diamond.make_diamond('C')
# Expected output:
answer = "  A  \n"\
         " B B \n"\
         "C   C\n"\
         " B B \n"\
          "  A  \n"
puts string
p string == answer
# => true