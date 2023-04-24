# Problem:
# Create a program that tracks the horizontal and depth positions of a submarine

class Submarine
  def initialize
    @depth = 0
    @horizontal_position = 0
  end

  def forward(num)
    valid_num?(num)
    @horizontal_position += num
  end

  def up(num)
    valid_num?(num)
    @depth -= num
  end

  def down(num)
    valid_num?(num)
    @depth += num
  end

  def valid_num?(number)
    raise ArgumentError.new("Incorrect input. Can only input a value > 0.") if number < 0
  end

  def to_s
    "Your submarine is located at a horizontal position of #{@horizontal_position} and a depth of #{@depth}."
  end
end

sub1 = Submarine.new
sub1.forward 5
sub1.down 5
sub1.forward 8
sub1.up 3
sub1.down 8
sub1.forward 2
p sub1.to_s == "Your submarine is located at a horizontal position of 15 and a depth of 10."
# => true
