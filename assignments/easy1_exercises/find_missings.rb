# Problem:
# Create a method that accepts an array of integers that are sorted
#   and returns an array that includes all the missing integers that
#   fall between the passed in array argument's largest integer and
#   smallest integer.

# Requirements based on test cases:
#  > if inputted argument has one integer, then an empty array should
#     be returned
#  > returned array should have integer elements sorted from smallest
#     to largest
#  > if inputted argument isn't missing any integers, then an empty
#     array should be returned

def missing(arr)
  missing_max = arr.max - 1
  missing_min = arr.min + 1
  missings = (missing_min..missing_max).select do |number|
    arr.include?(number) == false
  end
  missings
end

# Test Cases
p missing([-3, -2, 1, 5]) == [-1, 0, 2, 3, 4]
# => true
p missing([1, 2, 3, 4]) == []
# => true
p missing([1, 5]) == [2, 3, 4]
# => true
p missing([6]) == []
# => true
