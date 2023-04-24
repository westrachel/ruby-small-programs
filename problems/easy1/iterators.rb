# Problem Part 1:
# Create a custom #any? method that behaves like Array#any? to
#  practice yielding to a block

# Requirements:
#  > the array should stop being iterated over once the yielded to
#      block's return value is true
#  > do not use any of the following core ruby methods:
#     all?, any?, none? or one?

def any?(arr)
  index = 0
  value = false
  until index == arr.size
    value = yield(arr[index]) ? true : false
    break if value == true
    index += 1
  end
  value
end

# Check work:
p any?([1, 3, 5, 6]) { |value| value.even? } == true
# => true
p any?([1, 3, 5, 7]) { |value| value.even? } == false
# => true
p any?([2, 4, 6, 8]) { |value| value.odd? } == false
# => true
p any?([1, 3, 5, 7]) { |value| value % 5 == 0 } == true
# => true
p any?([1, 3, 5, 7]) { |value| true } == true
# => true
p any?([1, 3, 5, 7]) { |value| false } == false
# => true
p any?([]) { |value| true } == false
# => true

# Problem Part 2:
# Create a custom #all? method that behaves like Array#all? to
#  practice yielding to a block

# Requirements:
#  > the array should stop being iterated over once the yielded to
#      block's return value is false
#  > if the array argument is empty, all? should return true
#  > do not use any of the following core ruby methods:
#     all?, any?, none? or one?

def all?(arr)
  arr.each do |item|
    yield(item) ? true : (return false)
  end
  true
end

# Check work:
p all?([1, 3, 5, 6]) { |value| value.odd? } == false
# => true
p all?([1, 3, 5, 7]) { |value| value.odd? } == true
# => true
p all?([2, 4, 6, 8]) { |value| value.even? } == true
# => true
p all?([1, 3, 5, 7]) { |value| value % 5 == 0 } == false
# => true
p all?([1, 3, 5, 7]) { |value| true } == true
# => true
p all?([1, 3, 5, 7]) { |value| false } == false
# => true
p all?([]) { |value| false } == true
# => true

# Problem Part 3:
# Create a custom #none? method that behaves like Array#none? to
#  practice yielding to a block

# Requirements:
#  > the array should stop being iterated over once the yielded to
#      block's return value is true
#  > if the array argument is empty, none? should return true
#  > do not use any of the following core ruby methods:
#     all?, any?, none? or one?

def none?(arr)
  arr.each do |item|
    yield(item) ? (return false) : true
  end
  true
end

# Check work:
p none?([1, 3, 5, 6]) { |value| value.even? } == false
# => true
p none?([1, 3, 5, 7]) { |value| value.even? } == true
# => true
p none?([2, 4, 6, 8]) { |value| value.odd? } == true
# => true
p none?([1, 3, 5, 7]) { |value| value % 5 == 0 } == false
# => true
p none?([1, 3, 5, 7]) { |value| true } == false
# => true
p none?([1, 3, 5, 7]) { |value| false } == true
# => true
p none?([]) { |value| true } == true
# => true

# Problem Part 4:
# Create a custom #one? method that behaves like Array#one? to
#  practice yielding to a block

# Requirements:
#  > the array should stop being iterated over once the yielded to
#      block's return value evaluates as true for the second time
#  > if the array argument is empty, one? should return false
#  > do not use any of the following core ruby methods:
#     all?, any?, none? or one?

def one?(arr)
  true_counts = 0
  arr.each do |item|
    true_counts += 1 if yield(item)
    break if true_counts == 2
  end
  true_counts == 1 ? true : false
end

# Check work:
p one?([1, 3, 5, 6]) { |value| value.even? } == true
# => true
p one?([1, 3, 5, 7]) { |value| value.odd? } == false
# => true
p one?([2, 4, 6, 8]) { |value| value.even? } == false
# => true
p one?([1, 3, 5, 7]) { |value| value % 5 == 0 } == true
# => true
p one?([1, 3, 5, 7]) { |value| true } == false
# => true
p one?([1, 3, 5, 7]) { |value| false } == false
# => true
p one?([]) { |value| true } == false
# => true