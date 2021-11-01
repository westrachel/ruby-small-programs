# Problem part 1:
#  > recreate the each with index method

# Requirements:
#  > it should accept an Array argument
#  > both the array element and its index should be yielded to the block
#  > argument passed in should be the overall return value of the method

def each_with_index(arr)
  idx = 0
  while idx < arr.size
    yield(arr[idx], idx)
    idx += 1
  end
  arr
end

# Test case:
result = each_with_index([1, 3, 6]) do |value, index|
  puts "#{index} -> #{value**index}"
end

puts result == [1, 3, 6]
# => true

# Problem part 2:
#  > recreate the each with object method

# Requirements:
#  > method should return the final value of the object argument
#  > if the array argument is empty, then return the new object argument

def each_with_object(arr, new_obj)
  idx = 0
  until idx == arr.size
    yield(arr[idx], new_obj)
    idx += 1
  end
  new_obj
end

# Test cases:
result = each_with_object([1, 3, 5], []) do |value, list|
  list << value**2
end
p result == [1, 9, 25]
# => true

result = each_with_object([1, 3, 5], []) do |value, list|
  list << (1..value).to_a
end
p result == [[1], [1, 2, 3], [1, 2, 3, 4, 5]]
# => true

result = each_with_object([1, 3, 5], {}) do |value, hash|
  hash[value] = value**2
end
p result == { 1 => 1, 3 => 9, 5 => 25 }
# => true

result = each_with_object([], {}) do |value, hash|
  hash[value] = value * 2
end
p result == {}
# => true

# Problem part 3:
#  > recreate the Enumerable#each_cons method for arrays

# Requirements:
#  > consecutive pair of elements of the array argument hould be yielded to the block
#  > the overall method should return nil
#  > I'm assuming that the array argument will always be passed in with at least 2 elements

def each_cons(arr)
  arr[0..-2].each_with_index do |item, index|
    yield(item, arr[index + 1])
  end
  nil
end

# Test cases:
hash = {}
result = each_cons([1, 3, 6, 10]) do |value1, value2|
  hash[value1] = value2
end
p result == nil
# => true
p hash == { 1 => 3, 3 => 6, 6 => 10 }
# => true

hash = {}
result = each_cons([]) do |value1, value2|
  hash[value1] = value2
end
p hash == {}
# => true
result == nil


hash = {}
result = each_cons(['a', 'b']) do |value1, value2|
  hash[value1] = value2
end
p hash == {'a' => 'b'}
# => true
result == nil

# Problem part 4:
#  > update the each_cons method to accept another argument that represents
#     the number of elements to be yielded to the block
#  > so, if the 2nd argument is 3 then 3 elements should be yielded to the
#       block at once

def each_cons(arr, num)
  arr[0..(-num)].each_with_index do |item, index|
    elements_to_yield = []
    (num-1).times do |counter|
      elements_to_yield << arr[(index + counter + 1)]
    end
    yield(item, *elements_to_yield)
  end
  nil
end

# Test cases:
hash = {}
each_cons([1, 3, 6, 10], 1) do |value|
  hash[value] = true
end
p hash == { 1 => true, 3 => true, 6 => true, 10 => true }
# => true

hash = {}
each_cons([1, 3, 6, 10], 2) do |value1, value2|
  hash[value1] = value2
end
p hash == { 1 => 3, 3 => 6, 6 => 10 }
# => true

hash = {}
each_cons([1, 3, 6, 10], 3) do |value1, *values|
  hash[value1] = values
end
p hash == { 1 => [3, 6], 3 => [6, 10] }
# => true

hash = {}
each_cons([1, 3, 6, 10], 4) do |value1, *values|
  hash[value1] = values
end
p hash == { 1 => [3, 6, 10] }
# => true

hash = {}
each_cons([1, 3, 6, 10], 5) do |value1, *values|
  hash[value1] = values
end
p hash == {}
# => true