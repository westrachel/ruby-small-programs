# Problem:
# Create a custom zip method that acts like Array#zip.

# Requirements:
#  > the Array arguments shouldn't be changed
#  > a new array of the combined arrays should be returned that
#    is an array of 2-element subarrays
#  > can assume that both array arguments have the same # of elements


def zip(arr1, arr2)
  new_arr = []
  arr1.each_with_index do |item, index|
    new_arr << [item, arr2[index]]
  end
  new_arr
end

# Test Case:
p zip([1, 2, 3], [4, 5, 6]) == [[1, 4], [2, 5], [3, 6]]
# => true