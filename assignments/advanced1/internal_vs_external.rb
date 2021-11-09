# Problem:
# Create a new Enumerator object that can iterate over an
#   infinite list of factorials
#   >> Use this Enumerator object to print the first 7 factorials:
#         0! = 1
#         1! = 1
#         2! = 2
#         3! = 2*1
#         4! = 4 * 3 * 2 * 1
#         5! = 5 * 4 * 3 * 2 * 1

# First, to familiarize with creating a new Enumerator object,
#  create a new enumerator that will iterate over the first 7 factorials only
factorial = Enumerator.new do |x|
  7.times do |number|
    x << number
  end
end

factorial.each do |y|
  if y <= 1
    puts "#{y}! = 1"
  else
    puts "#{y}! = " + 1.upto(y).to_a.reduce(:*).to_s
  end
end
# =>
# 0! = 1
# 1! = 1
# 2! = 2
# 3! = 6
# 4! = 24
# 5! = 120
# 6! = 720

# Now use enumerator to iterate over potentially an infinite number of factorials:
#    <=> need to replace the 7.times do ... above to be more flexibile to accepting
#      more integers
# numbers = (0..Float::INFINITY).to_a.each
# creating an array up to infinity is time intensive, but should work

number_of_iterations = 10 # can toggle the value that this variable points to to set the number
#    of iterations

# Printing factorials:
numbers = (0..number_of_iterations).to_a.each

numbers.each_with_object("factorial!") do |num, obj|
  puts "#{num}! = 1" if num <= 1
  puts "#{num}! = #{1.upto(num).to_a.reduce(:*)}" if num > 1
end
# 0! = 1
# 1! = 1
# 2! = 2
# 3! = 6
# 4! = 24
# 5! = 120
# 6! = 720
# 7! = 5040
# 8! = 40320
# 9! = 362880
# 10! = 3628800
