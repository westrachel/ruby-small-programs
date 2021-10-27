# Problem: Part 1 - build out the ToDoList class to achieve the desired output below

# Based on desired output below the following needs to be create in the ToDoList class:
#    i. An add instance method that will add the passed in argument
#         to the calling ToDoList object's @todos array list
#        > this add instance method should check that the argument passed in
#          is a ToDoList object; if it's not then a TypeError should be raised
#           with the custom message "Can only add Todo objects"
#        > the calling ToDoList object should be returned
#    ii. size, first, last and to_a instance methods that can be called on a ToDoList
#         object; can leverage Array#size, Array#first, and Array#last methods to build these
#    iii. an item_at instance method that is defined with one parameter and returns
#          the object at that index position in the @todos array; a check needs to be done
#          to ensure the index is in bounds <=> or could just fetch, so that nil isn't returned
#           if the passed in argument number is out of bounds; fetch will raise an IndexError
#    iv. mark_done_at, mark_undone_at, and remove_at instance methods that are defined with one parameter
#         that should represent the index of the ToDo object that should be either be marked as done or undone
#           or should be removed and returned
#          <=> should use fetch w/in these instance methods to return IndexErrors as desired if the passed
#            in argument is not a valid index
#    v. shift and pop instance methods that remove and return either the first ToDo object from the
#        ToDoList object's @todos instance variable array
#    vi. done! instance method that marks all ToDo objects w/in the @todos instance variable of the calling
#        object as done
#    vii. custom to_s instance method that prints out a string representation of the @todos instance variable
#        with the header "----Today's Todos----"

# Problem: Part 2 - implement a ToDoList#each method
#    > this method should accept a block and then pass in each ToDo object to the block
#    > since each returns the calling object, in this case where the calling object is the
#       array that the @todos instance variable points to, the @todos instance variable should
#        be returned
#       > there is a getter method for @todos, so can use that

# Example of invoking the ToDoList#each method:
# list.each do |todo|
#   puts todo   # should call ToDo#to_s
# end

# Problem Part 3 - implement a ToDoList#select method
#   > can use ToDoList#each to iterate over @todos, and then need to apply selection

# Problem Part 4 - update the ToDoList#select method to return a new ToDoList
#     object to be more in line with Ruby's core library
#   > Hash#select returns a new hash
#   > Array#select returns a new array

# Problem Part 5 - update the ToDoList#Each method to return the calling ToDoList
#     object instead of the @todos array to be more in line with Ruby's core library

class ToDo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end

class ToDoList
  attr_accessor :title, :todos

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    if todo.class == ToDo
      @todos << todo
    else
      raise TypeError.new("Can only add Todo objects")
    end
    self.to_s
  end

  def size
    todos.size
  end

  def first
    todos.first
  end

  def last
    todos.last
  end

  def to_a
    todos
  end

  def done?
    todos.all? { |todo| todo.done }
  end

  def item_at(index)
    todos.fetch(index)
  end

  def mark_done_at(index)
    todos.fetch(index).done!
  end

  def mark_undone_at(index)
    todos.fetch(index).undone!
  end

  def done!
    todos.each { |todo| todo.done! }
  end

  def shift
    todos.shift
  end

  def pop
    todos.pop
  end

  def remove_at(index)
    todos.fetch(index) # ensures error is raised if index argument passed in is out of bounds
    todos.delete_at(index)
  end

  def current_list 
    todos.map { |todo| todo.to_s }
  end

  def each
    index = 0
    until index == todos.size
      yield(todos[index])
      index += 1
    end
    self
  end

  def select
    index = 0
    new_list = ToDoList.new("More ToDo's")
    until index == todos.size
      new_list.add(todos[index]) if yield(todos[index])
      index += 1
    end
    new_list
  end

  def to_s
    puts "---- Today's Todos ----"
    if current_list.empty?
      puts "Everything is complete!"
    else
      msg = <<~TEXT.chomp
      #{puts current_list.join("\n")}
      TEXT
      msg
    end
  end
end


# Desired Output to check ToDoList class is working as intended
todo1 = ToDo.new("Buy groceries")
todo2 = ToDo.new("Clean room")
todo3 = ToDo.new("Go to gym")
list = ToDoList.new("Today's Todos")

# ---- Adding to the list -----
p list.add(todo1)       # should add todo1 to end of list, returns list
# ---- Today's Todos ----
# [ ] Buy groceries
# ""
p list.add(todo2)       # should add todo2 to end of list, returns list
# ---- Today's Todos ----
# [ ] Buy groceries
# [ ] Clean room
# ""
p list.add(todo3)       # should add todo3 to end of list, returns list
# ---- Today's Todos ----
# [ ] Buy groceries
# [ ] Clean room
# [ ] Go to gym
# ""
# list.add(1)    # raises TypeError with message "Can only add Todo objects"
# => `add': Can only add Todo objects (TypeError)

p list.size == 3
# => true

p list.first          # should return todo1, which is the first item in the list
# => #<ToDo:0x00000000010d9c78 @title="Buy groceries", @description="", @done=false>

p list.last           # should return todo3, which is the last item in the list
# => #<ToDo:0x00000000010d9b88 @title="Go to gym", @description="", @done=false>

p list.to_a           # should return an array of all items in the list
# [#<ToDo:0x00000000028926d0 @title="Buy groceries", @description="", @done=false>, 
#  #<ToDo:0x0000000002892658 @title="Clean room", @description="", @done=false>,
#  #<ToDo:0x00000000028925e0 @title="Go to gym", @description="", @done=false>]

p list.done? == false      # returns true if all todos in the list are done, otherwise false
# => true

# ---- Retrieving an item in the list ----
#list.item_at                    # raises ArgumentError
# =>  wrong number of arguments (given 0, expected 1) (ArgumentError)

p list.item_at(1)                 # returns 2nd item in list (zero based index)
# => #<ToDo:0x0000000002892658 @title="Clean room", @description="", @done=false>

#list.item_at(100)               # raises IndexError
# => index 100 outside of array bounds: -3...3 (IndexError)

# ---- Marking items in the list -----
# list.mark_done_at               # raises ArgumentError
# => wrong number of arguments (given 0, expected 1) (ArgumentError)

list.mark_done_at(1)          # marks the 2nd item as done
p list.item_at(1)
# => #<ToDo:0x0000000002892658 @title="Clean room", @description="", @done=true>
# above output shows list.mark_done_at(1) method invocation worked as intended

#list.mark_done_at(100)        # raises IndexError
# => index 100 outside of array bounds: -3...3 (IndexError)

# mark_undone_at
# list.mark_undone_at             # raises ArgumentError
# =>  wrong number of arguments (given 0, expected 1) (ArgumentError)

list.mark_undone_at(1)          # marks the 2nd item as not done
p list.item_at(1)
# => #<ToDo:0x0000000002892658 @title="Clean room", @description="", @done=false>
# above output shows list.mark_undone_at(1) method invocation worked as intended

# list.mark_undone_at(100)        # raises IndexError
# => index 100 outside of array bounds: -3...3 (IndexError)

list.done!                      # marks all items as done
p list.done? == true
# => true

# ---- Deleting from the list -----
p list.shift                      # removes and returns the first item in list
# => #<ToDo:0x00000000028926d0 @title="Buy groceries", @description="", @done=true>

p list.to_s
#---- Today's Todos ----
#[X] Clean room
#[X] Go to gym
# ""
# the above output shows "Buy groceries" has been successfully removed

p list.pop                    # removes and returns the last item in list
# #<ToDo:0x00000000028925e0 @title="Go to gym", @description="", @done=true>
p list.to_s
#---- Today's Todos ----
# [X] Clean room
# ""

# list.remove_at                # raises ArgumentError
# => wrong number of arguments (given 0, expected 1) (ArgumentError)

#list.remove_at(100)             # raises IndexError
# =>  index 100 outside of array bounds: -1...1 (IndexError)
p list.remove_at(0)             # removes and returns the 1st item
# => #<ToDo:0x0000000002892658 @title="Clean room", @description="", @done=true>

# ---- Outputting the list -----
list.to_s                      # returns string representation of the list
#---- Today's Todos ----
#Everything is complete!



# Check that custom ToDoList#each method works as intended
todo4 = ToDo.new("Walk Dog")
list.add(todo4)

list.each do |todo|
  puts todo
end

# Check that custom ToDoList#select method works as intended
list2 = ToDoList.new("Tomorrow's Todos")
todo5 = ToDo.new("Take out recycling")
list2.add(todo4)
list2.add(todo5)

todo4.done!

results = list2.select { |todo| todo.done? }

# Problem Part 3 - check
#puts results.inspect # only the ToDo object that todo4 points to should have been selected
# => [#<ToDo:0x00000000023a7f58 @title="Walk Dog", @description="", @done=true>]
# <=> return value matches expectations

# Problem Part 4 - check - now the return should be a new ToDoList object with completed
#  tasks
puts results.inspect
# #<ToDoList:0x00000000024eead8 @title="More ToDo's",
# @todos=[#<ToDo:0x00000000024ef2a8 @title="Walk Dog", @description="", @done=true>]>
# <=> return value is a new ToDoList object as expected; made the @title in the custom
#   ToDoList#select method always be initialized to the string "More ToDo's"
