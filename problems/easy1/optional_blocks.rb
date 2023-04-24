# Problem:
# Create a method that accepts an optional block that if provided upon
#  method invocation, the block's return value should be the return value
#  of the method. If there isn't a block passed in, then the method should
#  return the string "Does not compute."

def compute(&block)
   block_given? ? yield : 'Does not compute.'
end

# Test method works:
p compute { 5 + 3 } == 8
# => true
p compute { 'a' + 'b' } == 'ab'
# => true
p compute == 'Does not compute.'
# => true