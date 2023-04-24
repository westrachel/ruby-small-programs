# Problem:
# Create a custom set class whose elements are numbers and
#   that can be manipulated as indicated/described in the
#   provided test cases

# Custom eql? instance method notes:
#  > this instance method compare only unique # elements of
#      2 separate set objects (should not compare size)
#  > also, the numbers can be in different orders and still
#     result in equal comparisons as long as the numbers in each
#     set being compared are the same

# Need to define a custom #== method for the tests containing
#  the assert_equal assertions
#    > based on test cases, the #== method can use the custom
#      eql? method previously defined, because adding a set
#       with the array [1, 3] to the set with an array [2, 3]
#       and comparing this joined set to [1, 2, 3] should
#       result in true (indicating these sets have the same value)

# Custom union instance method:
#  > should add together 2 separate sets

# Custom subset? instance method:
#  > should return a boolean that indicates if the calling object's array
#    numbers are all present in the argument set object's array
#  <=> based on test cases, testing if the calling object's array is a subset
#      of the argument set object's array and not the other way arround

# Custom disjoint method:
#  > should return a boolean that indicates whether the calling object's
#     array contains any of the same numbers as the argument set object's
#     array
#    <=> disjoint sets have 0 numerical elements in common

# Custom add method:
#   > can use Array#push w/in this instance method to add the number
#      argument passed in to the calling set object's array
#   > based on test cases, the return value of the add instance method
#      should be the calling set object

# Custom intersection instance method notes:
# > intersection method should return a new set object whose array
#    contains the numbers that are present in both the array of the
#    calling object and the array of the argument set object
#    > can iterate over the calling object's array of numbers and
#      select only the numbers that are also present in the argument
#      set object's array

# Custom difference instance method notes:
#  > the difference method should return a new set object whose
#     array representing its collection of elements that contains
#     the numbers that are present in the calling set object's array
#     that aren't present in argument set object's array
#  > can leverage the subtraction method as:
#       [3, 2, 1] - [2, 4] == [3, 1]

class CustomSet
  attr_reader :array

  def initialize(array=[])
    @array = array
  end

  def empty?
    array.empty?
  end

  def contains?(number)
    array.include?(number)
  end

  def eql?(other_set)
    array.uniq.sort == other_set.array.uniq.sort
  end

  def union(other_set)
    CustomSet.new((self.array + other_set.array))
  end

  def ==(other_set)
    self.eql?(other_set)
  end

  def subset?(other_set)
    array.all? { |num| other_set.array.include?(num) }
  end

  def disjoint?(other_set)
    array.all? do |num|
      other_set.array.include?(num) == false
    end
  end

  def intersection(other_set)
    present_in_both = array.select { |num| other_set.array.include?(num) }
    CustomSet.new(present_in_both)
  end

  def difference(other_set)
    CustomSet.new(array - other_set.array)
  end

  def add(number)
    @array << number
    self
  end
end