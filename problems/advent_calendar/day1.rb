# Problem:
# Create a program that counts the number of times a depth measurement increases

# Data:
#  Input: Number (representing the depth; so a whole number > 0)
#  Output: string ('increased', 'decreased', 'no change', 'N/A - no previous measurement')

# Test Case:
#199 (N/A - no previous measurement)
#200 (increased)
#208 (increased)
#210 (increased)
#200 (decreased)
#207 (increased)
#240 (increased)
#269 (increased)
#260 (decreased)
#263 (increased)

# Algorithm:
#  i. Establish a sonar class whose objects represent a sonar depth reader/recorder
# ii. Upon initializing a new object, establish an instance variable that points to an
#      empty array that will be used for keeping track of depths
#      > Also, upon initializing a new object, establish an instance variable that points to an
#         empty array that will store the string descriptions of whether the depth has increased
#         based on the depth reading numerical values 
#
# iii. Add a public setter instance method that records the depths read-in
#      > When this method is called add the numerical depth as an element to the array that the
#         @readings instance variable points to
#      > Check if the numerical depth being added to the array is greater than the numerical
#         depth of the last element in the array of @readings instance variable
#           > if it is than add "increased" to the array that the @depth_changes_log instance
#             variable points to
#           > if it's not and is less than the last number than add the string "decreased"
#           > if it's equal to the last value then add the string "no change"
#           > if there are currently no elements in the @depth_changes_log, then add the string
#              "N/A - no previous measurement"
#      > have the setter method return the change in depth string description
#             (to match the example given in the problem)
# iv. Add a public depth_increases_count instance method that determines the count of instances
#      where the depth increased and return that count

class Sonar
  def initialize
    @readings = []
    @depth_changes_log = []
  end

  def depth_increases_count
    @depth_changes_log.count("increased")
  end

  def sonar_sweep(depth)
    description = change_in_depth_description(depth)
    @depth_changes_log << description
    @readings << depth
    description
  end

  private

  def change_in_depth_description(latest_depth)
    prior_depth = @readings.last
    if @readings.empty?
      "N/A - no change in measurement"
    elsif prior_depth < latest_depth
      "increased"
    elsif prior_depth > latest_depth
      "decreased"
    else
      "no change"
    end
  end
end

# check work:
log1 = Sonar.new
p log1.sonar_sweep(199) == "N/A - no change in measurement"
# => true
p log1.sonar_sweep(200) == "increased"
# => true
p log1.sonar_sweep(208) == "increased"
# => true
p log1.sonar_sweep(210) == "increased"
# => true
p log1.sonar_sweep(200) == "decreased"
# => true
p log1.sonar_sweep(207) == "increased"
# => true
p log1.sonar_sweep(240) == "increased"
# => true
p log1.sonar_sweep(269) == "increased"
# => true
p log1.sonar_sweep(260) == "decreased"
# => true
p log1.sonar_sweep(263) == "increased"
# => true
p log1.depth_increases_count == 7
# => true