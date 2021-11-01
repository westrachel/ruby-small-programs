# Problem:
# Create a method that performs like map to practice yielding to a block.

# Requirements:
#  > it should accept an array argument
#  > if the array argument is empty, then an empty Array should be returned
#  > a new array should be returned consisting of the return values from
#      passing in an array element to the block

def map(array)
  idx = 0
  new_arr = []
  until idx == array.size
    new_arr << yield(array[idx])
    idx += 1
  end
  new_arr
end

# Test Cases:
p map([1, 3, 6]) { |value| value**2 } == [1, 9, 36]
# => true
p map([]) { |value| true } == []
# => true
p map(['a', 'b', 'c', 'd']) { |value| false } == [false, false, false, false]
# => true
p map(['a', 'b', 'c', 'd']) { |value| value.upcase } == ['A', 'B', 'C', 'D']
# => true
p map([1, 3, 4]) { |value| (1..value).to_a } == [[1], [1, 2, 3], [1, 2, 3, 4]]
# => true
