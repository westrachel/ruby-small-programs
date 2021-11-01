# Problem:
# Create a method that accepts 3 integer arguments representing the start
#    of a range, the end of a range, and a step value. The method should
#    yield to a block and should pass to the block each iteration's value.

def step(from, to, by)
  current_value = from
  until current_value > to
    yield(current_value)
    current_value += by
  end
end

# Test Case:
step(1, 10, 3) { |value| puts "value = #{value}" }
# value = 1
# value = 4
# value = 7
# value = 10