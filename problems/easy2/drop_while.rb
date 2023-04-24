# Problem:
# create a method the behaves like Array#drop_while to practice yielding
#  to a block

# Requirements:
#  > method should accept an array argument
#  > the method should return all elements of the array excluding elements
#     from the start of the array that had a block return value that evaluated
#     as true
#  > if the array argument only has elements that produce truthy block return
#     values or if the array argument is an empty array then an empty array
#     should be returned

def drop_while(arr)
  slice_start = 0
  all_true_counts = 0
  arr.each_with_index do |item, index|
    slice_start = index
    all_true_counts += 1 if yield(item)
    break if yield(item) == false
  end
  all_true_counts == arr.size ? [] : arr[slice_start..-1]
end

# Test Cases:
p drop_while([1, 3, 5, 6]) { |value| value.odd? } == [6]
# => true
p drop_while([1, 3, 5, 6]) { |value| value.even? } == [1, 3, 5, 6]
# => true
p drop_while([1, 3, 5, 6]) { |value| true } == []
# => true
p drop_while([1, 3, 5, 6]) { |value| false } == [1, 3, 5, 6]
# => true
p drop_while([1, 3, 5, 6]) { |value| value < 5 } == [5, 6]
# => true
p drop_while([]) { |value| true } == []
# => true
