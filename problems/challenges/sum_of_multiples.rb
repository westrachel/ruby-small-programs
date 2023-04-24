# Problem:
# Create a class that can accept a list of numbers on instantiation
#  and when chained with the class's public #to method will
#  return a sum of the multiples of the list of numbers given.

# Requirements:
#   > Only multiples that are less than the other number argument provided
#     in the to method invocation will be included in the summation
#   > if no list numbers is included in instantiation of an object of
#      created class, then set the default list of multiples as 3 and 5
#   > also, need both an instance method and a class method that return
#      the sum of multiples
#        > it seems like only the default factors [3, 5] should be used when
#            call the class to method to find the sum of multiples up to the
#            number argument passed in to the class to method
#   > multiples should not be repeated; for example:
#       number = 20
#       default factors = [3, 5]
#       multiples that should be summed = 3, 5, 6, 9, 10, 12, 15, and 18
#       sum of multiples that should be returned = 78

class SumOfMultiples
  attr_accessor :factors
  def initialize(*inputs)
    @factors = inputs
  end

  def self.to(limit)
    find_multiples([3,5], limit).sum
  end

  def to(limit)
    find_multiples(readjust_factors, limit).sum
  end

  private

  def readjust_factors
    if factors.empty?
      self.factors = [3, 5]
    end
    factors
  end

  def self.find_multiples(arr, limit)
    multiples = arr.each_with_object([]) do |factor, arr|
      multiple = factor
      until multiple >= limit
        arr << multiple
        multiple += factor
      end
    end
    multiples.uniq
  end

  def find_multiples(arr, limit)
    multiples = arr.each_with_object([]) do |factor, arr|
      multiple = factor
      until multiple >= limit
        arr << multiple
        multiple += factor
      end
    end
    multiples.uniq
  end
end
