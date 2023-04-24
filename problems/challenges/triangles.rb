# Problem:
# Create a Triangle class that has instance methods that can
#   assess if triangle instance objects are equilateral, isosceles,
#   or scalene triangles.

# Requirements:
#   > triangle side lengths must be nonzero
#   > sum of lengths of any 2 sides must be greater than the 3rd side's length

# Based on requirements, when invoke initialize method, I will want to call
#   validation method that will check the side length arguments to make sure
#   they create a valid triangle & if not then an ArgumentError should be
#   raised based on the test cases.

# Need to define the following instance methods:
#   > #kind, which should returne 'equilateral' if the triangle instance's 3 side
#      instance variables are all identical, 'isosceles' if only 2 of the triangle
#      instance's 3 side instance variables point to the same value, & scalene
#      if none of the 3 side instance variables point to the same value

class Triangle
  def initialize(side1, side2, side3)
    raise ArgumentError if valid_side_lengths?(side1, side2, side3) == false
    @side1 = side1
    @side2 = side2
    @side3 = side3
  end

  def valid_side_lengths?(x1, x2, x3)
    valid_side_summations?(x1, x2, x3) && [x1, x2, x3].all? { |x| x > 0 }
  end

  def valid_side_summations?(x1, x2, x3)
    comparison1 = (x1 + x2) > x3
    comparison2 = (x2 + x3) > x1
    comparison3 = (x1 + x3) > x2
    [comparison1, comparison2, comparison3].all? { |boolean| boolean == true }
  end

  def kind
    case [@side1, @side2, @side3].uniq.size
    when 3 then 'scalene'
    when 2 then 'isosceles'
    else 'equilateral'
    end
  end
  
end