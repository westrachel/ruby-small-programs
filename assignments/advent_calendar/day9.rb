# Problem:
# Find the sum of the risk levels of all the low points
#    in a given heightmap

# Data:
# input = heightmap that's a 5 row x 10 column grid with each
#   element representing a height
#   >> each height = an integer 0-9
#   <=> can model as a an array of 5 subarrays of 10 integer
#     height elements

# Requirements:
# low point = height point where adjacent heights are all larger
#    > adjacent points = heights to the right, left, directly above
#         and directly below; diagonal points are not considered
#         adjacent
#  risk level of a low point = 1 + the height of the low point

# Algorithm:
# 1. Iterate through the inputted aray of arrays representing the heightmap
#    and on each iteration over a height:
#     > push the given height element as a key to a hash with a distinct
#       "h#" and push the elements to the right of, to the left of, 
#       directly above, and directly below the height as values in an
#       array value to the hash
#           > valid element to the left of the height elment being iterated
#               over is 1 column index smaller than the current height
#               element as long as the current column index is not 0
#           > valid element to the right of the height element being iterated
#               over is 1 column index larger than the current height
#               element as long as the current column index is not 4
#           > valid element above is 1 row index smaller than the current height
#               element as long as the current row index is not 0
#           > valid element below is 1 row index larger than the current height
#               element as long as the current row index is not 4
# 2. Iterate over the hash containing each height and its neighboring 4 respective
#     heights and on each iteration:
#          > check if the height key being iterated over is smaller than the min
#            value of the key's corresponding array value
#          > exclude nils when finding the minimum integer element in the array
#              value containing neighboring heigh values
#             > nils will be returned when finding neighboring points of height
#                 points that are on the edge of the heightmap grid
#          > if the height key is smaller than the minimum neighboring height,
#            then push the height key to an array that stores all low points
# 3. Iterate over the array of all low points and slice from each height value
#      the first string element and conver the string element to an integer
#      representing the numerical height value
# 4. Sum each low point's integer height with 1 to find the total risk level
#      of all points and aggregate the risk levels to find the total_risk_level

class HeightMap
  def initialize(array)
    @heights = array
    @low_points = []
    @total_risk_level = 0
    @adjacent_pts = {}
  end

  def find_adjacent_heights
    height_num = 1
    @heights.each_with_index do |row, row_index|
      row.each_with_index do |height, column_index|
        height_key = "#{height}_h##{height_num}"
        neighboring_pts = find_neighbor_pts(row_index, column_index)
        @adjacent_pts[height_key] = neighboring_pts
        height_num += 1
      end
    end
    @adjacent_pts
  end

  def find_neighbor_pts(row_idx, column_idx)
    rt_pt = column_idx == 4 ? nil : @heights[row_idx][column_idx + 1]
    left_pt = column_idx == 0 ? nil : @heights[row_idx][column_idx - 1]
    above_pt = row_idx == 0 ? nil : @heights[row_idx - 1][column_idx]
    below_pt = row_idx == 4 ? nil : @heights[row_idx + 1][column_idx]
    [rt_pt, left_pt, above_pt, below_pt]
  end
    

  def low_points
    @adjacent_pts.each do |height_str, adj_pts_arr|
      adj_pts_arr.delete(nil)
      min_adjacent_height = adj_pts_arr.min
      if height_str[0].to_i < min_adjacent_height
        @low_points << height_str
      end
    end
    @low_points
  end

  def total_risk_level
    @low_points.each do |height_str|
      @total_risk_level += height_str[0].to_i + 1
    end
    @total_risk_level
  end
end

# check work:
# given example map:
map = [[2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
       [3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
       [9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
       [8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
       [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]]
heightmap1 = HeightMap.new(map)

heightmap1.find_adjacent_heights
# the given example map has 4 low points:
#   > low point of height 1, which is the 2nd height in map in the first row
#   > low point of height 0, which is the 10th height in the map in the first row
#   > low point of hieght 5, which is the 23rd height located as the third element
#         in the third row
#   > low point of height 5, which is the 47th height located in the last row of
#        the map
p heightmap1.low_points == ["1_h#2", "0_h#10", "5_h#23", "5_h#47"]
# => true
p heightmap1.total_risk_level == 15
# => true
