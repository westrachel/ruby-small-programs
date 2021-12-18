# Problem:
# Simulate a syntax error check that finds all incorrect first closing characters
#  and calculates the total syntax error

# Requirements:
# > input: multiple lines of opening and closing characters
# > find the first incorrect closing character (if one exists) in each line
#     > only consider this first incorrect closing character when calculating
#       the total syntax error
# > points: ')' = 3 points, ']' = 57, '}' = 1197, and '>' 25137

# Algorithm:
# i. Initialize a hash constant that stores each illegal closing character
#    and its associated point value
# ii. initialize a hash constant that keeps track of the counts of each
#     opening and closing character
#       > all counts should start at zero
#       > each key of the hash represents each unique character that can
#           exist in the inputted array
# iii. Iterate over the array input of subarrays and on each iteration:
#        > iterate over the subarray and for each character element in the
#            subarray:
#           > add 1 to the count value of the respective character in the 
#               counts hash
#           > check if the element being iterated over is a possible illegal
#               character and if it is then it will be 1 of the keys in the
#               element hash initialized in step 1
#           > if the element being iterated over is an illegal character, check
#             if its current count is greater than the count of its corresponding
#             open character & if it is:
#              >> push the confirmed illegal characters to an array storing all
#                 illegal characters found
#              >> break iteration over the current subarray line and move on to
#                 the next line
# iv. iterate over the array of confirmed illegal characters found and map the
#     character to its corresponding numerical error point value using the constant
#     initialized in step i
# v. sum the mapped error point values to find the total syntax eror score for the
#     given navigation subsystem input

class NavSystem
  attr_reader :total_syntax_error_score, :navigation_lines, :illegal_characters
  def initialize(lines)
    @navigation_lines = lines
    @total_syntax_error_score = 0
    @illegal_characters = []
  end

  INITIAL_CHAR_COUNTS = { '(' => 0, '[' => 0, '<' => 0, '{' => 0,
                          ')' => 0, ']' => 0, '>' => 0, '}' => 0 }

  CHAR_PAIRS = { ')' => '(', ']' => '[', '>' => '<', '}' => '{' }

  ERROR_POINTS = { ')' => 3, ']' => 57, '>' => 1197, '}' => 25137 }

  def find_illegal_chars
    navigation_lines.each do |subarray_line|
      line_char_counts = INITIAL_CHAR_COUNTS
      subarray_line.each do |char|
        line_char_counts[char] += 1
        if illegal?(char) && infraction?(line_char_counts, char)
          @illegal_characters << char
        end
        break if illegal?(char)
      end
    end
  end

  def illegal?(char)
    ERROR_POINTS.keys.include?(char)
  end

  def infraction?(line_char_counts, char)
    char_counts = line_char_counts[char]
    opening_char_counts = line_char_counts[CHAR_PAIRS[char]]
    char_counts > opening_char_counts || opening_char_counts - char_counts >= 3
  end

  def syntax_error_score
    scores = @illegal_characters.map { |char| ERROR_POINTS[char] }
    @total_syntax_error_score = scores.sum
  end
end
