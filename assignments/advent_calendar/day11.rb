# Problem:
# Model, with steps, flashing octopi and calculate the total
#   number of flashes after a given # of steps

# Requirements:
# > each octopus has an energy level integer number 0->9
# > there are 100 octopi in a 10x10 grid
#     > can model w/ an array of subarrays:
#        10 subarray 7 10 elements per subarray
# > if energy level is greater than 9, then the octopus flashes
#     > this adds 1 to the energy levels of all neighboring
#        octopi, after an octopus flashes, its energy level
#        decreases to zero
# > in each step, all octopi with energy level > 9 should flash
#    > all neighboring octopi of a flashing octopus should have
#       their energy level increased by 1
#    > octopus can only flash once per step
#    > initially, on each step each octopi's energy level should
#        be incremented by 1

# Algorithm:
# i. initialize a class variable that points to zero and will keep
#    track of the number of flashes
# ii. initialize a grid object with the input of the new class method
#     being a 10 element array assigned to an instance variable,
#     with each element being a subarray of 10 octopus objects
#      > each octopus should have an energy level and flashed this step
#         instance variable
# iii. iterate over the grid object's grid array and find each octopi's
#       neighboring octopis
#       >> neighboring octopis can be above/below/right/left/on a diagonal
#       >> can use each with index to keep track of the row and column indices
#          to find each octopi's neighboring octopies
#      >> push each octopus as a key and an array of all neighboring octopis to
#         a hash of all neighboring octopis
# iv. iterate over the hash of all octopi and their neighbors and increase the
#        energy of each octopus by 1
# v. iterate over the hash of all octopi and their neighbors on each iteration:
#      >> check if the octopus being iterated over has an en energy level of 9
#          and if it does:
#            >> add 1 to the value that the class variable points to that keeps
#               track of the total number of flashes
#            >> change the current octopus's energy level to 0 and the value that
#                the flashed this step instance variable points to to true
#            >> add 1 to the energy level's of the flashing octopus's neighboring
#                octopi if the neighboring octopi haven't flashed this step yet
#               <=> based on example steps, flashing octopi's energy levels should
#                 be at zero at the start of the next step if they flashed during
#                 the previous step
#      >> keep iterating over the hash of all octopi and neighboring octopi until
#         there are no octopi keys with an energy level equal to 9 that haven't
#         flashed during this respective step
# vi. repeat step iv and v for as many times as there are steps

class Octopus
  attr_accessor :energy, :flashed_this_step
  NRG_LVLS = (0..9).to_a
  def initialize(energy = NRG_LVLS.sample)
    @energy = energy
    @flashed_this_step = false
  end
end

class Grid
  attr_reader :octopi_and_neighbors
  @@number_of_flashes = 0

  def initialize(grid)
    @grid = grid
    @octopi_and_neighbors = {}
  end

  def find_all_neighboring_octopi
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |octo, column_idx|
        @octopi_and_neighbors[octo] = neighbor_octopi(row_idx, column_idx)
      end
    end
  end

  def neighbor_octopi(row, col)
    above = above_neighbors(row, col)
    below = below_neighbors(row, col)
    same_row = same_row_neighbors(row, col)
    neighbors = above + below + same_row
    neighbors.delete(nil)
    neighbors
  end

  def above_neighbors(row_idx, column_idx)
    above_left = (row_idx == 0 || column_idx == 0) ? nil : @grid[row_idx - 1][column_idx - 1]
    above = row_idx == 0 ? nil : @grid[row_idx - 1][column_idx]
    above_rt = (row_idx == 0 || column_idx == 9) ? nil : @grid[row_idx - 1][column_idx + 1]
    [above_left, above, above_rt]
  end

  def below_neighbors(row_idx, column_idx)
    below_left = (row_idx == 9 || column_idx == 0) ? nil : @grid[row_idx + 1][column_idx - 1]
    below = row_idx == 9 ? nil : @grid[row_idx + 1][column_idx]
    below_rt = (row_idx == 9 || column_idx == 9) ? nil : @grid[row_idx + 1][column_idx + 1]
    [below_left, below, below_rt]
  end

  def same_row_neighbors(row_idx, column_idx)
    rt = column_idx == 9 ? nil : @grid[row_idx][column_idx + 1]
    left = column_idx == 0 ? nil : @grid[row_idx][column_idx - 1]
    [rt, left]
  end

  def model_steps(num_steps)
    num_steps.times do |_|
      increase_octopi_energy!
      flash_relevant_octopi!
      reset_flash_tracker!
    end
    display_number_flashes(num_steps)
  end

  def increase_octopi_energy!
    octopi_and_neighbors.each do |octopus, _|
      octopus.energy += 1
    end
  end

  def reset_flash_tracker!
    octopi_and_neighbors.each do |octopus, _|
      octopus.flashed_this_step = false
    end
  end

  def display_number_flashes(num_steps)
    puts "After #{num_steps} steps, there were #{@@number_of_flashes} number of flashes."
  end

  def flash_relevant_octopi!
    while flashable_octopus?
      flash_octopi
    end
  end

  def flash_octopi
    @octopi_and_neighbors.each do |octopus, neighbors|
      if octopus.energy > 9 && octopus.flashed_this_step == false
        @@number_of_flashes += 1
        octopus.energy = 0
        octopus.flashed_this_step = true
        neighbors.each do |neighbor_octopus|
          neighbor_octopus.energy += 1 if neighbor_octopus.flashed_this_step == false
        end
      end
    end
  end

  def flashable_octopus?
    all_octopi.any? do |octopus|
      octopus.energy > 9 && octopus.flashed_this_step == false
    end
  end

  def all_octopi
    @grid.each_with_object([]) do |row, array|
      row.each do |octopus|
        array << octopus
      end
    end
  end
end

# check work:
row1 = [5,4,8,3,1,4,3,2,2,3]
row2 = [2,7,4,5,8,5,4,7,1,1]
row3 = [5,2,6,4,5,5,6,1,7,3]
row4 = [6,1,4,1,3,3,6,1,4,6]
row5 = [6,3,5,7,3,8,5,4,7,8]
row6 = [4,1,6,7,5,2,4,6,4,5]
row7 = [2,1,7,6,8,4,1,7,2,1]
row8 = [6,8,8,2,8,8,1,1,3,4]
row9 = [4,8,4,6,8,4,8,5,5,4]
row10 = [5,2,8,3,7,5,1,5,2,6]

all_rows = [row1, row2, row3, row4, row5, row6, row7, row8, row9, row10]
octopi_grid = []
all_rows.each do |row|
  octopi = row.map { |energy| Octopus.new(energy) }
  octopi_grid << octopi
end

grid1 = Grid.new(octopi_grid)
grid1.find_all_neighboring_octopi
grid1.model_steps(10) # should print that there have been 204 flashes
# => After 10 steps, there were 204 number of flashes.
