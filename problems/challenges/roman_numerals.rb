# Problem:
# Create a class that stores 1 instance variable, a number, and
#   contains an instance method that can translate number to a
#   roman numberal

# Requirements:
# i. Should be able to convert numbers up to 3000 to Roman Numerals
# ii. Roman Numerals:
#      (1..10) = I, II, III, IV, V, VI, VII, VIII, IX, X
#      L = 50, XL = 40, XXX = 30, LXX = 70, LXXX = 80
#      C = 100, XC = 90, CCC = 300, D = 500, CD = 400, DC = 600
#      1000 = M, 2000 = MM, 3000 = MMM

# Algorithm for .to_roman instance method:
# i. Check if the number argumnet is <= 10, if it is, automatically
#      look up the number from the roman numeral Hash Constant
#     > let the keys be numbers and the corresponding values be
#        the roman numeral version
# ii. If the number is greater than 10 than will need to deconstruct the
#      number into parts. Determine the size of the number argument,
#      b/c the extent the number needs to be deconstructed depends on how
#      many digits it has
#     > ex: 24 is a 2 digit number that needs to be deconstructed to 20 and 4
#        and then 20 and 4 can be looked up from the roman_numerals constant
#        hash to find the corresponding number
#     > ex: 1367 is a 4 digit number that needs to be deconstructed to 1000,
#          300, 60, and 7 and then these individual numbers' roman numeral
#          values can be looked up from the roman_numerals constant
# iii. If the number is 2 digits long, then call a 2-digit converter instance method
#      that:
#        a. calculates the remainder of the 2-digit number when it's divided by 10
#        b. finds the multiple of ten that corresponds with the number, which is the
#           return value of subtracting the remainder found in (a) from the number itself
#        c. create a roman_numeral variable that points to a string whose number of 
#            X's or L's and X's corresponds w/ whether the 2-digit number is in the
#            range 10-20, 20-30, 30-40, 40-50, 50-60, 60-70, 70-80, 80-90, or 90-100
#               > this is based on the multiple of ten value found in step (b)
#               > if the num - remainder (multiple of ten value) is <= 30, then return
#                   a string that is equal to "X" * (multiple of ten value / 10)
#                     <=> so, if the multiple of 10 is 20, then will return "XX" as desired
#                        b/c 20 / 10 = 2 and "X" * 2 == "XX"
#               > if the num - remainder is 40 then return "XL"
#               > if the num - remainder is 50 then return 'L'
#               > if the num - remainder is 90 then return 'XC'
#               > otherwise return 'L' concatenated w/ 'X' * ((num - remainder - 50)/10)
#        d. if the remainder isn't zero, then add to the roman_numeral string the string
#            returned from looking up the remainder in the roman_numerals hash
#
# iv. If the number is 3 digits long, then call the 3-digit converter instance method
#      that:
#        a. calculates the remainder of the 3-digit number when it's divided by 100
#        b. finds the multiple of 100 that corresponds w/ the number, which is the
#             return value of substracting the remainder found in (a) from the number
#             itself
#        c. create a roman_numeral variable that points to a string whose number of
#            C's and D's corresponds w/ whether the number is in the range 100-200,
#            200-300, ... 900-1000
#        d. if the remainder is:
#              > 2-digits, then push to the roman_numeral string the roman numeral that
#                  is returned from calling the previously defined 2-digit roman numeral
#                  converter instance method with the remainder passed-in as an argument
#              > single digit that is >0, then push to the roman_numeral string the roman
#                  numeral string the string returned from looking up the single digit
#                  remainder key's value from the roman_numeral constant hash 
#             > zero; then don't need to add anything to the roman numeral string
#
# v. If the number is 4 digits long, then call the 4-digit converter instance method that:
#        a. calculates the remainder of the 4-digit number when it's divided by 1000
#        b. finds the multiple of 1000 that corresponds w/ the number, which is the return
#            value of subtracting the remainder found in (a) from the number itself
#        c. create a roman_numeral variable that points to a string whose number of M's
#            corresponds with whether the number is in the range 1000-2000, or 2000-3000
#              <=> given assumption is that no number arguments will be >= 4000
#        d. if the remainder is:
#             > 3-digits, then push to the roman_numeral string the roman numeral returned
#                from calling the 3-digit converter instance method with the remainder
#                as the argument
#             > 2-digits, then push to the roman_numeral string the roman numeral returned
#                from calling the 2-digit converter instance method with the remainder as the
#                argument
#             > single digit (>0), then push to the roman_numeral string the value associated w/
#                the remainder's 
#             > zero; then don't need to anything

# Refactoring idea:
#   > add 0 to the ROMAN_NUMERALS hash as a key and make its value an empty string ""
#      <=> removes having to check if the remainder is zero and therefore removes required
#           case statement logic from the conver_four... instance method

ROMAN_NUMERALS = { 0 => "", 1 => 'I', 2 => 'II', 3 => 'III',
                   4 => 'IV', 5 => 'V', 6 => 'VI', 7 => 'VII',
                   8 => 'VIII', 9 => 'IX', 10 => 'X' }

class RomanNumeral
  attr_reader :num
  def initialize(number)
    @num = number
  end

  def to_roman
    return ROMAN_NUMERALS[num] if num <= 10
    case num.to_s.size
    when 2 then convert_two_digit_num(num)
    when 3 then convert_three_digit_num(num)
    else convert_four_digit_num_up_to_3000(num)
    end
  end

  private

  def convert_two_digit_num(num)
    remainder = num % 10
    roman_numeral = case (num - remainder)
                    when (10..30) then "X" * ((num - remainder) / 10)
                    when 40 then "XL"
                    when 50 then "L"
                    when 90 then "XC"
                    else "L" + "X" * ((num - remainder - 50) / 10)
                    end
    roman_numeral << ROMAN_NUMERALS[remainder]
    roman_numeral
  end

  def convert_three_digit_num(num)
    remainder = num % 100
    roman_numeral = case (num - remainder)
                    when (100..300) then "C" * ((num - remainder) / 100)
                    when 400 then "CD"
                    when 500 then "D"
                    when 900 then "CM"
                    else "D" + "C" * ((num - remainder - 500) / 100)
                    end
  roman_numeral << (remainder.to_s.size == 2 ? convert_two_digit_num(remainder) : ROMAN_NUMERALS[remainder])
  roman_numeral
  end

  def convert_four_digit_num_up_to_3000(num)
    remainder = num % 1000
    roman_numeral = "M" * ((num - remainder) / 1000)
    roman_numeral << case remainder.to_s.size
                     when 3 then convert_three_digit_num(remainder)
                     when 2 then convert_two_digit_num(remainder)
                     else ROMAN_NUMERALS[remainder]
                     end
    roman_numeral
  end
end