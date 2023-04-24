# Problem Part 1:
# Create a method that accepts an array argument and a block and
#   returns an integer that represents the count of the number of
#   times the block returns true.

# Requirements:
#  > each element of the array argument should get passed to the block
#     to be evaluated
#  > if pass in an empty array argument the count returned should be 0

def count(arr)
  counts = 0
  arr.size.times do |idx|
    counts += 1 if yield(arr[idx])
  end
  counts
end

# Check Work:
p count([1,2,3,4,5]) { |value| value.odd? } == 3
# => true
p count([1,2,3,4,5]) { |value| value % 3 == 1 } == 2
# => true
p count([1,2,3,4,5]) { |value| true } == 5
# => true
p count([1,2,3,4,5]) { |value| false } == 0
# => true
p count([]) { |value| value.even? } == 0
# => true
p count(%w(Four score and seven)) { |value| value.size == 5 } == 2
# => true


# Problem Part 2 (from easy2):
# modify the method to accept an a list argument
def count(*inputs)
  counts = 0
  inputs.each do |element|
    counts += 1 if yield(element)
  end
  counts
end

p count(1, 3, 6) { |value| value.odd? } == 2
# => true
p count(1, 3, 6) { |value| value.even? } == 1
# => true
p count(1, 3, 6) { |value| value > 6 } == 0
# => true
p count(1, 3, 6) { |value| true } == 3
# => true
p count() { |value| true } == 0
# => true
p count(1, 3, 6) { |value| value - 6 } == 3
# => true