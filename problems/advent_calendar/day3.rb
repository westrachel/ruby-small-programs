# Problem:
# Create a program that can find the gamme rate and the epsilon rate
#   based on the provided diagnostic report. Use the gamma rate and
#   epsilon rate to calculate the power consumption in decimal value
#   of the submarine.

# Input:
# > a multiline string with 5 digit binary sequences on each line

# Requirements:
# i. gamma rate is derived by:
#    > finding the most common number at each position of each 5-digit
#       sequence if most sequences have 0 as the first digit, then the
#       first number of gamma rate is 0
# ii. the epsilon rate is derived by:
#    > finding the least common number at each position
#     <=> epsilon rate has the opposite binary digit at each position
#       as the gamme rate
# iii. the power consumption is derived by first converting the gamma
#       rate number to decimal and the epsilon rate to decimal and then
#       multiplying these values together

# Binary Sequence to Decimal Conversion:
# > multiply each binary digit (0 or 1) by 2 raised to the power of the
#    binary digit's place in the sequence and then sum the results
# example:
#     01001 = 0*2^4 + 1*2^3 + 0*2^2 + 0*2^1 + 1*2^0
# > can use times method to iterate over a dynamic binary string sequence
#    > the "0" or "1" string element at the zeroth index should be
#       multiplied by 2^(dynamic_value) where dynamic_value will always
#       be 4 for the zeroth index since the binary sequence is 5 digits

class Diagnostics
  attr_reader :counts_at_each_position
  NUM_TO_POSITION = { 0 => :position1,
                      1 => :position2,
                      2 => :position3,
                      3 => :position4,
                      4 => :position5 }

  def initialize(multiline_report)
    @report = multiline_report
    @counts_at_each_position = { :position1 => {"0" => 0, "1" => 0},
                                 :position2 => {"0" => 0, "1" => 0},
                                 :position3 => {"0" => 0, "1" => 0},
                                 :position4 => {"0" => 0, "1" => 0},
                                 :position5 => {"0" => 0, "1" => 0} }
  end

  def gamma_rate
    find_counts_at_each_position
    gamma_rate_string = ""
    @counts_at_each_position.each do |key, value_hash|
      max_value_pair = value_hash.select { |k, v| v == value_hash.values.max }
      gamma_rate_string << max_value_pair.keys[0]
    end
    convert_binary_to_decimal(gamma_rate_string)
  end

  def epsilon_rate
    find_counts_at_each_position
    epsilon_rate_string = ""
    @counts_at_each_position.each do |key, value_hash|
      min_value_pair = value_hash.select { |k, v| v == value_hash.values.min }
      epsilon_rate_string << min_value_pair.keys[0]
    end
    convert_binary_to_decimal(epsilon_rate_string)
  end

  def find_counts_at_each_position
    string_nums = scrub_report
    string_nums.each do |string|
      string.chars.size.times do |index|
        string[index]
        @counts_at_each_position[NUM_TO_POSITION[index]][string[index]] += 1
      end
    end
  end

  def scrub_report
    @report.split(/\s/)
  end

  def convert_binary_to_decimal(string)
    decimal_value = 0
    power = 4
    string.size.times do |index|
      decimal_value += (string[index].to_i * 2 ** power)
      power -= 1
    end
    decimal_value
  end

  def power_consumption
    self.epsilon_rate * self.gamma_rate
  end
  
end

sample_report = <<~MSG.chomp
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
MSG

report1 = Diagnostics.new(sample_report)

# check work:
p report1.epsilon_rate == 9
# => true
p report1.gamma_rate == 22
# => true
p report1.power_consumption == 198
# => true
