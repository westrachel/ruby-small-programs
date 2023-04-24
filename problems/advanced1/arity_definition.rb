# Problem: Using the code examples below, explain the differences
#   between procs, blocks, and lambdas in regards to arity and definitions.

# Group 1
my_proc = proc { |thing| puts "This is a #{thing}." }
puts my_proc
# => #<Proc:0x000000000141a298@test.rb:2>
puts my_proc.class
# => Proc
my_proc.call
# => This is a .
my_proc.call('cat')
# => This is a cat.

# Group 2
my_lambda = lambda { |thing| puts "This is a #{thing}." }
my_second_lambda = -> (thing) { puts "This is a #{thing}." }
puts my_lambda
# => #<Proc:0x0000000001419fc8@test.rb:9 (lambda)>
puts my_second_lambda
# => #<Proc:0x0000000001419fa0@test.rb:10 (lambda)>
puts my_lambda.class
# => Proc
my_lambda.call('dog')
# => This is a dog.
#my_lambda.call
# => Argument error (given 0, expected 1)
# my_third_lambda = Lambda.new { |thing| puts "This is a #{thing}." }
# => unitialized constant Lambda (NameError)

# Group 3
def block_method_1(animal)
  yield
end

block_method_1('seal') { |seal| puts "This is a #{seal}."}
# => This is a .
#block_method_1('seal')
# => no block given (yield) LocalJumpError

# Group 4
def block_method_2(animal)
  yield(animal)
end

block_method_2('turtle') { |turtle| puts "This is a #{turtle}."}
# => This is a turtle.
block_method_2('turtle') do |turtle, seal|
  puts "This is a #{turtle} and a #{seal}."
end
# => This is a turtle and a .
block_method_2('turtle') { puts "This is a #{animal}."}
# => undefined local variable or method `animal' for main:Object (NameError)

# Observations:
# Arity refers to if and how many arguments you need to pass to a block, proc,
#  or lambda. In the group 1 example above, a new proc object is instantiated and
#  the local variable my_proc is initialized to reference it. The proc object
#  was defined with a parameter, thing, however, when the proc is subequently called
#  the first time, no argument is passed in. The fact that no error is raised due to
#  not passing in an argument to the proc call demonstrates that procs have lenient arity.

# In contrast, lambdas have strict arity, as shown by the group 2 example. In the group 2
#   section, a lambda is instantiated and is defined wtih a parameter, thing. When this
#   lambda is subsequently called without an argument, an exception is raised due to not
#   passing in the expected number of arguments, which demonstrates strictness in adhering
#   to passing in the required number of arguments when working with lambdas.
# On a separate note, both the proc and the lambda that are instantiated in group 1 and group 2
#   belong to the same class, Proc, as shown by the outputted Proc value that's output after
#   passing in my_proc and my_lambda to the puts method invocations.

# The group 3 example demonstrates that methods also have strict arity as an exception is raised
#   when the block_method_1 method is invoked without a block passed in. The method in group 3 is defined
#   to explicitly yield to a block, and Ruby doesn't let it slide when no block is passed in as an argument
#   during method invocation.

#  Another takeaway from group 3 is that block_method_1 is defined with one parameter, animal, and is
#   defined to yield to a block, but since animal is not passed into the yield invocation within the
#   method definition, the parameter isn't passed to the block. As a result, when block_method_1 is
#   invoked with the string 'seal' passed in as an argument, the string 'seal' doesn't get passed to
#   the block. This explains with the output is "This is a ." instead of "This is a seal.", 'seal' didn't
#   get passed to the block and assigned to the block's local variable seal and therefore when the local
#   variable seal is incorporated into the string through string interpolation and to_s is called on the
#   local variable seal, no string word is returned.

# The group 4 example demonstrates that blocks have lenient arity as a block can be defined with 2 parameters
#  and still be processed without raising an exception even though only 1 argument is passed into the block.
#  This is demonstrated by the second invocation of block_method_2, where the block passed in as an argument
#  to the method has 2 parameters, turtle and seal, but only one argument is passed in and assigned to the turtle
#  local variable within the block. No exception is raised and instead the block prints out "This is a turtle and
#  a ."

# Another takeaway from group 4 is that if a block isn't defined with a parameter, and the local variable animal
#  hasn't been initialized prior to the last invocation of block_method_2 then an undefined local variable exception
#  will be raised. If I had initialized a local variable animal to point to the string 'sea horse' on any of the lines
#  prior to the block_method_2('turtle') { puts "This is a #{animal}."} method invocation with a block, then I would
#  not have raised an exception as blocks hold on to a memory of their surrounding environment and even though animal
#  isn't defined within the block that is equal to the code: { puts "This is a #{animal}."}, if animal is initialized prior
#  to the block, then the block would be able to access the object that the animal local variable points to and "This is a 
#  seahorse." would have been outputted.
