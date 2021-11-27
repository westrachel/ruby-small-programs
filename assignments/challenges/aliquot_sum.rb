# Problem:
# Create a class containing a class method that will determine
#   whether a natural number is a perfect number is abundant,
#   perfect, or deficient.

# Requirements:
# i. Natural Numbers: >= 0 & a whole/integer
#       <=> natural numbers = 1, 2, 3, ...
# ii. Aliquot Sum = sum of positive divisors into a number
#       excluding the number itself
#  Ex: aliquot sum of 15 is 9 (= 3 + 5 + 1)
#       <=> the factors of 15 = 3, 5, 1 & 15
# iii. Perfect Number = natural number that has an aliquot sum
#        that is equal to itself 
#     Ex: 6 (= 3 + 2+ 1 = 6)
# iv. Abundant Number = natural number that has an aliquot sum
#       greater than itself
#     Ex: 24 (= 1 + 2 + 3 + 4 + 6 + 8 = 26)
# v. Deficient Number = natural number that has an aliquot sum
#     less than itself
#     Ex: 15

# Class Method Algorithm:
# i. Check if the argument is a natural number; if not raise a StandardError
#       > if the number has a decimal/is a float or if the number is <= 0 then
#           it is not natural
# ii. Create a range array that contains the number 1 through the
#       half of the passed in natural number argument
# iii. Select from the array created in (ii) all the numbers that
#        divide evenly into the natural number argument and store
#        the selected elements into a new array
# iv. Iterate through the selected first half of factors and find
#       their factor pair
# v. Add the first half of factors array to the second half of factors
#     array
# vi. Remove from the new array created in step (v) the passed in
#       natural number argument (since 1 will divide into every number
#       and 1's factor pair is the number itself)
# vii. Call unique on the array of remaining factors post step (vi)
# viii. Sum the remaining factors
# ix. Check if the sum calculated in step (viii) is:
#        > greater than natural number argument
#            > if so, then return the string 'abundant',
#        > less than the natural number argument
#            > if so, then return 'deficient'
#        > equal to the natural number argument
#            > if so, then return the string 'perfect'

class PerfectNumber
  def self.classify(num)
    raise StandardError if (num <= 0 || num.is_a?(Float))
    factors = all_factors(first_half_of_factors(num), num).uniq
    factors.delete(num)
    find_category(factors.uniq.sum, num)
  end

  def self.first_half_of_factors(num)
    (1..(num/2)).to_a.select { |factor| num % factor == 0 }
  end

  def self.all_factors(initial_half_of_factors, number)
    second_half_of_factors = initial_half_of_factors.map { |factor| number / factor }
    initial_half_of_factors + second_half_of_factors
  end

  def self.find_category(aliquot_sum, natural_num)
    case aliquot_sum
    when (1...natural_num) then 'deficient'
    when ((natural_num + 1)..Float::INFINITY) then 'abundant'
    else 'perfect'
    end
  end
  
end