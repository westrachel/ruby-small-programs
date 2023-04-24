# test file that follows assert-style syntax:

require 'minitest/autorun' # load necessary minitest gem files

require_relative 'car' # specify file name in same directory to make it
#  accessible to the test(s)

class CarTest < MiniTest::Test # create test class that subclasses from MiniTest::Test
  def test_wheels # tests are created through test_ instance method definition
    car = Car.new
    assert_equal(4, car.wheels) # first argument of assert_equal represents the expected value
    #  the second argument of assert_equal represents the actual value to test
  end
end

# Example of a failing test + corresponding output:
require 'minitest/autorun'

require_relative 'car'

class CarTest < MiniTest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end

  def test_bad_wheels
    skip            # can use skip keyword to skip certain tests 
    car = Car.new
    assert_equal(3, car.wheels)
  end
end

# output will indicate a failure w/ 'F.' and will detail where
#  the failure is and what the actual value was versus the expected value