# Problem:
# find the product associated with a continuous non-empty subarray within the array
#   of elements that are negative or non-negative

# Input: an array containing integers, positive or negative
# Output: integer

# examples/notes:
#  a. if array input has a lot of negative numbers, want to consider the largest numerical element within the array
#      >> push to array of products, the value of the largest element of the inputted array b/c that may be greater
#          then the product of any neighboring elements

# Algorithm:
# i. return the product of the entire array if all elements in the array are > 0
# ii. establish a local variable products that points to an empty array
# iii. find all the continuous products in the given inputted array
#       [2, 3, -2, 4]
#       2*3, 2*3*-2, 2*3*-2*4, 3*-2, 3*-2*4, -2*4, 4
#       a. establish a starting index that points to the local variable of the times method
#            invocation with a block 0
#             >> call the times method on the size of the inputted array
#       b. within the block invoke the times method with a block and establish an ending index
#           that points to the local variable of the times method
#             >> call the times method on the size of the inputted array
#       c. push to the array the product of all the elements returned by subsetting the inputted
#           array from the index associated with the starting index local variable to the index
#           associated with the number that the ending index local variable points to
#            how to calc product of elements in a subarray:
#                 >> establish a local variable product = 1
#                 >> iterate through each of the elments in the subarray and multiple the integer
#                     that the product local variable points to by the element being iterated over
#                 >> reassign the product local variable to the return value of the multiplication
# iv. return the largest value of the local variable products that points to the array of all 
#       possible continuous subproducts or values possible

def product_all_elements(array)
  product = 1
  array.each do |integer|
    product *= integer
  end
  array.empty? ? 0 : product
end

def max_subproduct(arr)
  return product_all_elements(arr) if arr.all? { |x| x > 0 }
  products = []
  arr.size.times do |starting_index|
    arr.size.times do |ending_index|
      products << product_all_elements(arr[starting_index..ending_index])
    end
  end
  products.max
end

# test cases:
p max_subproduct([2,3,-2,4]) == 6
# => true
p max_subproduct([-2,0,-1]) == 0
# => true
