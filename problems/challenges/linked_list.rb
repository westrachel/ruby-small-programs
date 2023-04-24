# Problem:
# create a simple linked list class and an element class
#  that can be added to linked list objects

# requirements:
# > list should follow last in, first out order when adding/removing
#      elements
# > list objects are constrained to numbers within the range 0 -> 10
# > need to define peek and next instance methods for the list class
#    that return nil or a value from the list
#     > can establish an instance variable current_index that is
#        initialized to point to -1 and that keeps track of what
#        value to return from the list based on acting as an index
#        to slice the array that the at @list instance variable points to
#          <=> using an array to store values that get pushed or popped
#            from the list array
#          > initializing the current_index to point to -1, because the list
#             should follow last in, first out when looking at elements
#             as shown by one of the test cases where after all numbers 0 -> 10
#             are added to the list, 10 is returned when peek is called
#     > if peek is called, then slice the @list array and return the value
#        located at the index whose numerical value is the value that
#        @current_index points to
#           > subtract 1 from @current_index, so if peek is called again, the
#             next value to the left (that was 2nd to last in terms of values added
#             to the list) in the array will be returned or nil should be
#             returned if there are no more values
#     > if next is called, then subtract 1 from the number @current_index points to
#        and return the value located at the @current_index position of the
#         linked list that @list points to
#   > for the list class, there should be a head instance method that initializes
#      a new Element class object that accepts the values in the array @list points
#       to of the list object that called the head instance method
#       > along with this, need to define a tail? instance method for the Element
#          class that seems to return the last value of the potential >= 1 values
#          that the Element object has stored in the list that the @values instance
#           variable points to in the Element class
#   > based on test cases, the next method when called on an Element class instance works
#       differently than when it's called on the list class, as the list class works
#       backward looking first at the last value added to the list and then the 2nd
#       to last value, and so on; the Element class also has a next instance method
#       but it starts by iteratively looking at the first value in the list of values
#       and then the second value and so on until it reaches the last value

class Element
  attr_reader :values
  def initialize(*values)
    @values = values
    @current_index = 0
  end

  def datum
    @values.flatten.nil? ? nil : @values.flatten[@current_index]
  end

  def next
    if @values.size == 0
      nil
    else
      @current_index += 1
      @values.flatten[@current_index]
    end
  end

  def tail?
    @values.last
  end
end

class SimpleLinkedList
  def initialize(arr=[])
    @list = arr
    @current_index = -1
    @addend_or_subtract = -1
  end

  def self.from_a(array)
    self.new(array)
  end

  def head
    Element.new(@list)
  end

  def peek
    return self[0] if self.is_a?(Array)
    return_value = @list.nil? ? nil : @list[@current_index]
    @current_index += @addend_or_subtract
    return_value
  end

  def next
    @current_index += @addend_or_subtract
    @list[@current_index]
  end

  def empty?
    @list.empty?
  end

  def size
    @list.nil? ? 0 : @list.size
  end

  def push(value)
    @list << value
  end

  def pop
    @list.pop
  end

  def to_a
    @list
  end

  def reverse
    @current_index = 0
    @addend_or_subtract = 1
    @list.reverse!
    self
  end
end