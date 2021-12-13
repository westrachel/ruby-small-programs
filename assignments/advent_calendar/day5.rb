# Problem:
# Given a list of points denoting the starting and ending points of lines
#   determine the number of points in the grid that are overlapped by
#   at least 2 lines

# Requirements:
# > grid is 10 x 10
# > grid values are either "." or a #
#    <=> number represents how many lines cross that respective point
# > the point at the top left corner has the coordinates 0,0
# > the point in the bottom right corner has the coordinates 9,9
# > lines inputted represent horizontal or vertical lines only,
#   so that the line 1,1 -> 1,3 consists of points where x coordinate
#   is always 1 and y coordinate increments from 1 to 3 across the 3
#   points that make up the line

# Data:
# Inputs:
#   > a list of line starting and ending point coordinates
#      > can store these line start/endpoints as strings in an array
#      > a Grid class upon initialization can store in array format
#         10 rows by 10 columns of "." default points that indicate
#         no lines have been mapped
#      > add an instance method to map out the vent lines inputted
#         by updating the values in the array that represents the 10x10
#         grid

# Map_vent_lines instance method algorithm:
# i. iterate over the inputted array of vent line starting/ending points
#     and on each iteration:
#     > find the coordinates of all the points that make up that line in
#       terms of integer values, as can use the integer values to reassign
#       grid point values in the array that the @grid instance variable
#       points to
#          a. determine if the line is horizontal or vertical by comparing
#              if the element at the zeroth and 7th index are the same
#              (vertical) else the line is horizontal, since not dealing w/
#               diagonal or zigzag lines based on the problem's requirements
#          b. if the line is vertical, then map out all the points that
#              make up the vertical line by pushing to an array subarrays
#              that contain each point's x and y coordinate values
#                  > the x value remains the same for all the points
#                         x in integer terms = string[0].to_i
#                 where the string == the starting/ending coordinates string
#                  > the y value should increment from the initial y1 value
#                     to the last y value determined based on the inputted
#                     starting/ending point string where:
#                          y1 in integer terms = string[2].to_i
#                          last y point = string[9].to_i
#          c. if the line is horizontal, then map out all the points that
#              make up the horizontal line by pushng to an array subarrays
#              the contain each point's x and y coordinate values
#                  > the y value remains the same for all the points
#                        y in integer terms = string[2].to_i
#                  > the x value should increment from the initial x1 value
#                     to the last x value
#                         x1 = string[0].to_i
#                         last x = string[7].to_i
#           d. iterate over the array of subarrays that represent each (x,y)
#              coordinaate pair of the particular line and on each iteration:
#                > change the value in the @grid instance variable located 
#                  at the point the respective (x, y) pair corresponds to
#                   >> the relevant row array/element of the @grid array is
#                      indexed at the value that the y variable points to
#                   >> the relevant element w/in the row array to be changed
#                      is located at the index position designated by the
#                      value that the x variable points to
#                > if the value currently at the (x, y) point in the array
#                   that @grid points to is ".", then change the value to 1
#                   otherwise increment the current integer value located
#                   at (x,y) by 1

class Grid
  attr_reader :grid

  def initialize
    @grid = []
    10.times do |_|
      row = []
      10.times { |_| row << "." }
      @grid << row
    end
  end

  def map_vent_lines(lines)
    lines.each do |start_and_end_pts|
      all_points = find_all_points(start_and_end_pts)
      p all_points
      map_points!(all_points)
    end
  end

  def vertical_line?(line_coordinates)
    line_coordinates[0] == line_coordinates[7]
  end

  def find_all_points(start_and_end_pts)
    if vertical_line?(start_and_end_pts)
      find_all_vertical_pts(start_and_end_pts)
    else
      find_all_horizontal_pts(start_and_end_pts)
    end
  end

  def find_all_vertical_pts(starting_ending_pts)
    x = starting_ending_pts[0].to_i
    y1 = starting_ending_pts[2].to_i
    last_y = starting_ending_pts[9].to_i
    all_points = []
    all_ys = (last_y > y1 ? (y1..last_y).to_a : (last_y..y1).to_a)
    all_ys.each do |y_value|
      all_points << [x, y_value]
    end
    all_points
  end

  def find_all_horizontal_pts(starting_ending_pts)
    y = starting_ending_pts[2].to_i
    x1 = starting_ending_pts[0].to_i
    last_x = starting_ending_pts[7].to_i
    all_points = []
    all_xs = (last_x > x1 ? (x1..last_x).to_a : (last_x..x1).to_a)
    all_xs.each do |x_value|
      all_points << [x_value, y]
    end
    all_points
  end

  def map_points!(line_pts_array)
    line_pts_array.each do |one_pt_subarray|
      y = one_pt_subarray[0]
      x = one_pt_subarray[1]
      current_pt_value = @grid[x][y]
      case current_pt_value
      when "." then @grid[x][y] = 1
      else @grid[x][y] += 1
      end
    end
  end

  def pts_with_multiple_vents
    counts_2_or_more = 0
    @grid.each do |row_array|
      counts_2_or_more += row_array.count(2)
    end
    counts_2_or_more
  end
end

# check work:
grid1 = Grid.new
grid1.map_vent_lines(["0,9 -> 5,9", "9,4 -> 3,4", "2,2 -> 2,1", "7,0 -> 7,4",
                      "0,9 -> 2,9", "3,4 -> 1,4"])

p grid1.grid == [[".",".",".",".",".",".",".",1,".","."],
                 [".",".",1,".",".",".",".",1,".","."],
                 [".",".",1,".",".",".",".",1,".","."],
                 [".",".",".",".",".",".",".",1,".","."],
                 [".",1,1,2,1,1,1,2,1,1],
                 [".",".",".",".",".",".",".",".",".", "."],
                 [".",".",".",".",".",".",".",".",".", "."],
                 [".",".",".",".",".",".",".",".",".", "."],
                 [".",".",".",".",".",".",".",".",".", "."],
                 [2,2,2,1,1,1,".",".",".","."]]
# => true

p grid1.pts_with_multiple_vents == 5
# => true
