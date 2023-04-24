# Problem:
# Create a method that accepts a positive integer and and returns an
#  array of all the possible divisors of that integer in any order.

def divisors(int)
  divisors = []
  int.times do |num|
    factor = num + 1
    divisors << factor if int % factor == 0
  end
  divisors
end

# Test cases:
p divisors(1) == [1]
# => true
p divisors(7) == [1, 7]
# => true
p divisors(12) == [1, 2, 3, 4, 6, 12]
# => true
p divisors(98) == [1, 2, 7, 14, 49, 98]
# => true
p divisors(99400891) == [1, 9967, 9973, 99400891]
# => true

# Further exploration:
#  Create a solution that doesn't check all integers between 1 and the
#   passed in argument to improve the speed

def find_half_of_factors(num)
  about_half_int = (num / 2) + 1
  1.upto(about_half_int).select do |divisor|
    num % divisor == 0
  end
end

def find_all_factor_pairs(array, num)
  all_divisor_pairs = array.map do |divisor|
    [divisor, (num / divisor)]
  end
  all_divisor_pairs.flatten.uniq.sort
end

def divisors(int)
  find_all_factor_pairs(find_half_of_factors(int), int)
end

# Test cases:
p divisors(1) == [1]
# => true
p divisors(7) == [1, 7]
# => true
p divisors(12) == [1, 2, 3, 4, 6, 12]
# => true
p divisors(98) == [1, 2, 7, 14, 49, 98]
# => true
p divisors(99400891) == [1, 9967, 9973, 99400891]
# => true