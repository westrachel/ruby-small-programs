# Problem:
# Create a program that calculates the fuel costs associated
#   with aligning all crab submarines to all possible horizontal
#   positions and then find the minimum fuel cost associated with
#   alignment

# Data:
# > input = list of the horizontal position of each crab
#      <=> an array

# Requirements:
# > moving 1 crab 1 spot costs 2 fuel
# > crabs are somehwat close to each other, but don't all start at
#     the same spot; example had crab submarines located at integer
#     horizontal positions ranging from 0 to 16

# Assumption:
#   > crab submarines will be located to start as positions
#      represented by the integes 0 to 20

# Algorithm:
#  i. Find and store all horizontal positions of existing crab
#      submarines in an array
#        > iterate over the aray that the @crabs instance variable
#           points to and map each crab submarine's horizontal aray
#        > find the smallest existing horizontal position and the largest
#           horizontal position
#        > find all horizontal positions between the smallest and largest
#           position
# ii. Iterate over each possible horizontal alignment position and
#      calculate the cost of moving each crab to that position
#        > on each iteration over a possible horizontal position,
#           iterate over each crab and find their horizontal position
#        > subtract the alignment position being considered from the
#           position of the crab that's being iterated over to find
#           the number of steps they have to take
#        > find the absolute value of the move the crab has to take
#          by multipling their movement/# of steps by -1 if the
#          previous subtraction resulted in finding a movement < 0
#        > the cost for moving is the number of movements in absolute value
#           in fuel terms based on the example given
#        > add that crab's movement cost to a running total value
#           that calculates the total cost of aligning all crabs to
#           that particular position
#        > push the particular horizontal position and its associated
#          total fuel cost as a key/value pair to a hash tracking
#          all possible alignments' fuel costs
# iii. select from the hash tracking all possible alignments' fuel coss
#       the key/value pair with the samllest value, which corresponds with
#       the samllest fuel cost

class CrabSubmarine
  attr_accessor :horizontal_position

  def initialize(horizontal_position)
    @horizontal_position = horizontal_position
  end
end

class CrabArmy

  def initialize(horiz_positions)
    @crabs = horiz_positions.each_with_object([]) do |position, arr|
      arr << CrabSubmarine.new(position)
    end
  end

  def all_horizontal_positions
    existing_positions = @crabs.map { |crab| crab.horizontal_position }
    (existing_positions.min .. existing_positions.max).to_a
  end

  def all_alignment_costs
    all_horizontal_positions.each_with_object({}) do |position, hash|
      hash[position] = total_cost_of_alignment(position)
    end
  end

  def total_cost_of_alignment(position)
    total_cost = 0
    @crabs.each do |crab_submarine|
      movement = (crab_submarine.horizontal_position - position)
      abs_value_movement = (movement < 0 ? -1 * movement : movement)
      total_cost += abs_value_movement
    end
    total_cost
  end

  def min_fuel_cost
    all_alignment_costs.select { |position, cost| all_alignment_costs.values.min == cost }
  end

  def display_min_fuel_cost
    puts "The minimum cost to align all crabs at #{min_fuel_cost.keys[0]} is #{min_fuel_cost.values[0]} fuel."
  end
end

# check work:
army1 = CrabArmy.new([16, 1, 2, 0, 4, 2, 7, 1, 2, 14])

p army1.all_alignment_costs[3] == 39
# => true
p army1.all_alignment_costs[10] == 71
# => true
p army1.all_alignment_costs[1] == 41
# => true
army1.display_min_fuel_cost # should be 37 fuel & should align at position 2
# => The minimum cost to align all crabs at 2 is 37 fuel.
