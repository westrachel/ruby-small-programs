# Problem: Find the sum of the 2 integers provided without using
#  the + or - operators

# Inputs:
#   > 2 integers

# Output:
#   > a sum of these 2 integers

# Assumptions/Requirements:
#  > inputted values can be negative
#      >> [-1000, 1000]
#  > algorithm should be able to handle inputting the same number twice

# example 1:
# Input: a = 1, b = 2
# Output: 3

# Algorithm:
# 1. Find the minimum of the 2 integers inputted
# 2. Establish an array of integers that range from -1000 to 1000 inclusive
#    arr = (-1000..1000).to_a
# 3. Slice the array of the in scope range of integers from the minimum of the 2 integers
#     inputted to the upper bound/rightmost element of the array
#      slice_start_idx = arr.index(minimum of 2 integers from (i))
#      end_idx = arr.size - 1
# 4. From the sliced subset found in (iii.), I want to find the new ending index for
#     an additional slice
#      end_idx_pt2 = 2nd integer argument
# 5. Return the last element from the sliced subarray found in part 4

def find_minormax(int1, int2, min_or_max)
  case min_or_max
  when "min"
    [int1, int2].min
  when "max"
    [int1, int2].max
  end
end

def sum_two(x1, x2)
  min, max = find_minormax(x1, x2, "min"), find_minormax(x1, x2, "max")
  sum_options = (-1000..1000).to_a
  initial_start_idx = sum_options.index(min)
  initial_end_idx = sum_options.size - 1
  sum_options = sum_options[initial_start_idx..initial_end_idx]
  second_end_idx = max
  sum_options[0..second_end_idx].last
end

# check work:
p sum_two(1, 2) == 3 # => true
p sum_two(2, 3) == 5 # => true
p sum_two(2, 2) == 4 # => true
p sum_two(-100, 100) == 0 # => true
