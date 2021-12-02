# Problem:
# Create a Robot class that creates a new random robot
#   name for each object instantiated

# Requirements:
# i. Name instance variable should be 5 digits
#      > first 2 digits = random capitalized letters
#      > last 3 digits = random numbers 
# ii. Names should be random, but should not assign
#      the same name twice if possible
#        <=> assuming the if possible contingency is
#          based on the fact that if you instantiated
#          enough objects would eventually have to reuse
#          a name (but would have to create a lot of robot
#          objects to reach that point)

# Algorithm for generating new name notes:
#  i. in the initialize method can assign a local variable name to the return of an
#      instance method that generates a random name created by concatenating 2 sampled
#      letters pulled from a letters constant and 3 numerical digits (converted to string)
#      sampled from a digits constant
#  ii. before assigning the robot object's @name instance variable to the randomly sampled
#       name check that no previous robot has been assigned that name before by checking
#       if a class robot instance variable that points to an array of all previously used
#       robot names includes that name already
#        > use a looping construct that reassigns the name local variable (local to the
#          initialize instance method) if the class variable array already contains the
#          randomly generated name
#        > once have verified the name hasn't been used before break out of the loop and
#          push the randomly generated name to the class variable array and assign the name
#          instance variable for the object being created to the randomly generated name
#          string
#  iii. need to also define a reset instance method that reassigns the robot's name to a new
#         random name
#           > can extract the loop name validation process to an instance method that can be
#              used in both the initialize method and reset instance method

# Initial Algorithm's Assumption:
#  > initial algorithm logic passed all test cases but assumed there wouldn't be enough robot
#     objects created and/or that existing robot names won't be reset enough times to cause
#     the looping construct to endlessly run
#  > There are 26 letters in the alphabet and 10 digits and each randomly generated name
#     contains 5 digits; so would run into endless loop if > 676000 robot objects are
#     created or if robot names are reset 676000 times
#      unique # of possible names = 26 * 26 * 10 * 10 * 10 = 676000
#  > Algorithm improvements:
#     i. when a robot's name gets reset to a different name, remove the robot object's
#         current name from the @@all_active_robot_names class variable, so that the name
#         string can be reused again
#     > this ensures that won't run into endless loop issue b/c no new name can be found due
#         to resetting robot's names a lot
#     ii. update the valid_random_name instance method's looping construct logic to check
#         if all random names have been exhausted
#           > add another class variable that initially points to zero and keeps track of
#             the number of robots created
#           > increment this robot class variable by 1 whenever a new robot object is created
#           > w/in valid_random_name instance method's looping construct, add a break
#             condition that will stop the loop from endlessly looping if more than 676000
#             robot's have been created
#               > the new robot being instantiated will still get assigned a new name at that
#                 point, but the name will be a repeat (but that's okay b/c at that point
#                 have exhausted all unique names)

class Robot
  attr_reader :name

  LETTERS = ('A'..'Z').to_a
  DIGITS = (0..9).to_a

  @@all_active_robot_names = []
  @@number_of_robots = 0

  def initialize
    new_name = valid_random_name(generate_new_random_name)
    @@all_active_robot_names << new_name
    @name = new_name
    @@number_of_robots += 1
  end

  def reset
    @@all_active_robot_names.delete(name)
    self.name = valid_random_name(generate_new_random_name)
  end

  private

  def valid_random_name(random_name)
    until @@all_active_robot_names.include?(random_name) == false
      random_name = generate_new_random_name
      break if @@number_of_robots > 676000
    end
    random_name
  end

  attr_writer :name

  def generate_new_random_name
    name = ""
    2.times { |_| name << LETTERS.sample }
    3.times { |_| name << DIGITS.sample.to_s }
    name
  end

end
