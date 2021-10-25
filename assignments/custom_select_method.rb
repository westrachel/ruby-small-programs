# Problem: create a select method definition that performs the same as the Array#select
#    method to practice writing methods that yield to blocks

# Array#select behavior:
#   i. Array#select is called on an array & takes a block
#   ii. Each element of the calling array is yielded to the block
#   iii. If the block evaluates as true for the current element, that
#        element is selected to be later included in the overall method
#        invocations returned array
#   iv. The returned array is a new array

def select(array)
  index = 0
  return_array = []     # initialize a new array to return from the overall custom method
  until index == array.size
    if yield(array[index])    # pass the current array element being iterated over to the block & if the block's return value is true then 
      return_array << array[index]    # push the array argument's element to the new array that will be returned
    end
    index += 1
  end
  return_array  # return a new array (could be empty or could have <= # of elements as the array object that's passed in as an argument)
end

# check custom select method works as intended:
array = [1, 2, 3, 4, 5]

p select(array) { |num| num.odd? } == [1, 3, 5]  
# => true
p select(array) { |num| puts num } == []
# => true      note: puts num returns nil, so each yielding to the block should evaluate as false for
#               this example and accordingly no elements of the original array will be selected
p select(array) { |num| num + 1 } == [1, 2, 3, 4, 5]
# => true      note: "num + 1" will evaluate as true so all elements of array passed in as an argument
#                      should be pushed to the new returned array to true
    