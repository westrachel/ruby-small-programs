# Problem:
# recreate the max_by method to practice yielding to a block

# Requirements:
#  > return nil if the array argument is empty
#  > return value should be array element that returns the
#     largest value

def max_by(arr)
  return nil if arr.empty?
  items_and_returns = arr.each_with_object({}) do |element, hash|
    hash[element] = yield(element)
  end
  max_return = items_and_returns.values.max
  items_and_returns.key(max_return)
end

# Test cases:
p max_by([1, 5, 3]) { |value| value + 2 } == 5
# => true
p max_by([1, 5, 3]) { |value| 9 - value } == 1
# => true
p max_by([1, 5, 3]) { |value| (96 - value).chr } == 1
# => true
p max_by([[1, 2], [3, 4, 5], [6]]) { |value| value.size } == [3, 4, 5]
# => true
p max_by([-7]) { |value| value * 3 } == -7
# => true
p max_by([]) { |value| value + 5 } == nil
# => true