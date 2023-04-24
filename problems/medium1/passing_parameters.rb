# Problem Part 1:
#  Edit the gather method, so that how the items are displayed
#     is flexibile/dependable on the block passed to the gather
#     method as an argument on invocation

items = ['apples', 'corn', 'cabbage', 'wheat']

def gather(items)
  puts "Let's start gathering food."
  yield(items)
  puts "Nice selection of food we have gathered!"
end

# Test:
gather(items) do |array|
  puts "Gathering " + array.join(', ')
end
# Let's start gathering food.
# Gathering apples, corn, cabbage, wheat
# Nice selection of food we have gathered!

# Problem Part 2:
# Create a method that accepts an array argument, passes the array
#   to a block where the first 2 elements of the array are ignored

def gather_pt2(arr)
  yield(arr)
end

flyable = ["raven", "finch", "hawk", "eagle"]

gather_pt2(flyable) do |_, _, *flyable|
  puts "Look at that " + "#{flyable.join(' & ')}"
end
# => Look at that hawk & eagle

# Problem Part 3:
# Use the first gather method to produce the desired output below
# (i)
# desired output:
#Let's start gathering food.
#apples, corn, cabbage
#wheat
#We've finished gathering!

gather(items) do |*ingredients, other_ingredient|
  puts ingredients.join(', ')
  puts other_ingredient
end

# (ii)
# desired output:
# Let's start gathering food.
# apples
# corn, cabbage
# wheat
# Nice selection of food we have gathered!

gather(items) do |ingredient1, *ingredient2, ingredient3|
  puts ingredient1
  puts ingredient2.join(', ')
  puts ingredient3
end

# (iii)
# desired output:
# Let's start gathering food.
# apples
# corn, cabbage, wheat
# We've finished gathering!

gather(items) do |ingredient, *other_ingredients|
  puts ingredient
  puts other_ingredients.join(', ')
end

# (iii)
# desired output:
# Let's start gathering food.
# apples, corn, cabbage, and wheat
# We've finished gathering!

gather(items) do |ingredient1, ingredient2, ingredient3, ingredient4|
  puts ingredient1 + ', ' + ingredient2 + ', ' + ingredient3 + ', ' + ingredient4
end
