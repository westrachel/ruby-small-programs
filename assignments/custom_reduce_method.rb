# Problem: create a reduce method definition that performs similarly to Enumerable#reduce
#   (although the custom method requirements are simpler than Enumerable#reduce from core Ruby)
#    method to practice writing methods that yield to blocks

# Requirements:
#  i. Custom reduce method should be defined with 1 parameter
#     that corresponds with an array and an optional 2nd parameter
#     that corresponds with the default value for the accumulator
#  ii. the yielded to block's return value is what the accumulator should
#        be reassigned to
#  iii. the accumulator is passed into the yielded block on each iteration
#         alongside with one element of the passed in array argument

def reduce(array, accumulator=0)
  index = 0
  until index == array.size
    accumulator = yield(accumulator, array[index])
    index += 1
  end
  accumulator
end

# check custom reduce method works as intended:
array = [1, 2, 3, 4, 5]

p reduce(array) { |acc, num| acc + num } == 15
# => true
p reduce(array, 10) { |acc, num| acc + num } == 25
# => true
#reduce(array) { |acc, num| acc + num if num.odd? }
# => NoMethodError: undefined method `+' for nil:NilClass

# Further exploration:
# Alter the implementation so that the default accumulator value
#   is first element of the collection
def reduce(array, accumulator=array[0])
  index = 1
  until index == array.size
    accumulator = yield(accumulator, array[index])
    index += 1
  end
  accumulator
end


# check more flexible custom reduce method works as intended:
p reduce(['a', 'b', 'c']) { |acc, value| acc += value } == 'abc'
# => true
p reduce([[1, 2], ['a', 'b']]) { |acc, value| acc + value } == [1, 2, 'a', 'b']
# => true
