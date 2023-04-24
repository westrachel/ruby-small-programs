# problem: find the max depth of a given tree that corresponds with the number of nodes or levels of the tree

# input: array of node values, either integers or null if there is no node
#    at the respective level/row within the tree

# output: an integer that represents the max depth

# examples:
# > inputted array will list the value at every level even if it's null
# > can set a row_value variable that points to 0 initially and can be used
#    to subset the array to extract the value of the nodes in that particular row
# > if the first row/level of the tree contains 1 node, the 2nd level/row contains
#     2 nodes, ..., the nth level/row will contain n+1 nodes

# goal: iterate through the given array and assess all the element values
#    that correspond with nodes in a particular level/row of a tree and confirm
#    that at least 1 node has a value that is not equal to null

# Algorithm:
# i. assign a local variable row_num to point to 1 initially
# ii. assign a num_nodes_in_row local variable that points to zero initially
# iii. assign a max_depth variable that initially points to one
#     >> I'm assuming that it's not possible to input an empty array [] and that
#           each input will correspond with a tree that does have a root node
# iv. start a looping mechanism and on each iteration:
#     a. subset the inputted array from the row_num index to the num_nodes_in_row
#          ex: on the first iteration, will subset the array from [0..0]
#                   [3,9,20,"null","null",15,7][0..0] # => 3
#                   [3,9,20,"null","null",15,7][1..1] # => 3
#        <=> the return value or values represent the values of the nodes in that
#            level/row of the tree

# [3,9,20,"null","null",15,7][0..0] # subset to extract the single element of the first row
# [3,9,20,"null","null",15,7][1..2] # subset to extract the 2 elements in the 2nd row
# [3,9,20,"null","null",15,7][3..6] # subset to extract the 2 elements in the 3rd row
# [3,9,20,"null","null",15,7,"null","null","null","null","null","null","null","null"][7..16] 

# number of elements in each row:
# 1, 2, 2*(number of elements in row before it)

def number_elements_in_row(row_level)
  return 1 if row_level == 1
  2 * number_elements_in_row(row_level - 1)
end

number_elements_in_row(1)
number_elements_in_row(2)
# => 2
number_elements_in_row(3)
# => 4

#starting_index = prior_ending_index + 1
#ending_index = prior_ending_index + number_elements_in_row(current_row_number)

def max_depth(arr)
  row_num = 2
  starting_idx = 0
  ending_idx = 0
  max_depth = 1
  loop do
    starting_idx = ending_idx + 1
    ending_idx += number_elements_in_row(row_num)
    slice = arr[starting_idx..ending_idx]
    break if slice.all? { |element| element == "null" }
    if slice.uniq.any? { |x| (0..9).to_a.include?(x) }
      max_depth += 1
    end
    row_num += 1
  end
  max_depth
end

# check work:
p max_depth([3,9,20,"null","null",15,7]) == 3
# => true

p max_depth([1, "null", 2]) == 2
# => true
