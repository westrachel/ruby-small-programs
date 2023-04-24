# Problem:
# Calculate the number of ilsands in a given 2D binary grid

# Input: an array of subarrays that contains strings
#   > each "1" represents an island
#   > each "0" represents water

# Output: integer representing the number of islands in the grid

# Requirements:
#  > an island consists of adjacent "1" strings and are connected
#      either horizontally or vertically

# Algorithm:
# 1. initialize an empty hash where each key will represent an island
#     and its corresponding value will be an array of subarrays that represent
#     coordinates of the land within the island
# 2. iterate through the given grid array of subarrays and check if the 
#       element being iterated over is a "1" and if it is then:
#         > check if any of its horizontal or vertical neighbors (based on coordinates)
#            are associated with an island currently within the island coordinate hash
#         > if any of its neighbors exist within the island coordinate hash, then
#             add the current element's coordinates as a subarray to the same respective
#             island key's corresponding array value
# 3. find the number of keys in the island coordinate hash

def neighbor_coordinates(grid, curr_coords)
  row = curr_coords[0]
  col = curr_coords[1]
  [[row, col - 1], [row, col + 1], [row - 1, col], [row + 1, col]]
end

def find_island(adjacents, all_islands)
  island = nil
  all_islands.each do |island_num, coordinates|
    reassign_flag = adjacents.any? do |coords|
                      coordinates.include?(coords)
                    end
    island = island_num if reassign_flag
  end
  island
end

def next_id(islands)
  case islands.keys.size
  when 0 then 1
  else islands.keys.max + 1
  end
end

def num_islands(grid)
  island_coords = {}
  grid.each_with_index do |arr, row|
    arr.each_with_index do |str, col|
      if str == "1"
        current_coords = [row, col]
        neighbors = neighbor_coordinates(grid, current_coords)
        existing_island = find_island(neighbors, island_coords)
        if existing_island
          island_coords[existing_island] << current_coords
        else
          island_coords[next_id(island_coords)] = [current_coords]
        end
      end
    end
  end
  island_coords.keys.size
end

# Check work:
grid1 = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
p num_islands(grid1) == 1
# => true

grid2 = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
p num_islands(grid2) == 3
# => true
