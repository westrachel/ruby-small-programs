# test file that follows expectation style syntax:

require 'minitest/autorun'

require_relative 'car'

describe 'Car#wheels' do
  it 'has 4 wheels' do
    car = Car.new
    _(car.wheels).must_equal 4           # expectation
  end
end

# test output when this file is run reads just like assertion style's test output