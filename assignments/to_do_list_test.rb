# Problem:
# Create tests (via instance methods) to verify the following ToDoList class instance methods work:
#  > size, first, last
#  > shift: for shift, test if both:
#      i. the first item is returned
#     ii. the first item is removed from the @todos instance variable of the ToDoList object
#  > pop: for pop, test if both:
#      i. the last item is returned
#     ii. the last item is removed from the @todos instance variable of the ToDoList object
#  > done?
#     > test should return true if all items are done
#      <=> since not all items are completed in setup instance method, expected value of this method is false
#  > add
#     > test should check a TypeError is returned if a non-ToDo object is attempted to be passed in as an
#        argument in the add method invocation
#  > item_at
#     > IndexError should be raised if specify out of bounds index
#  > mark_done_at, mark_undone_at
#  > done!
#  > remove_at
#     > IndexError should be raised if specify out of bounds index
#  > to_s
#     > add a subsequent to_s instance method that verifies the returned
#        multiline string when all todos are completed
#  > each
#     > first, test that the each method is iterative
#     > second, test that the each method returns the original object
#  > select
#  > <<
#     > test that this method adds a ToDo object like add
#     >

require 'minitest/autorun'
require "minitest/reporters"
require 'simplecov'
SimpleCov.start

Minitest::Reporters.use!

require_relative 'to_do_list'

class ToDoListTest < MiniTest::Test

  def setup
    @todo1 = ToDo.new("Buy milk")
    @todo2 = ToDo.new("Clean room")
    @todo3 = ToDo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = ToDoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_same(@todos[0], @list.first)
  end

  def test_last
    assert_same(@todos[2], @list.last)
  end

  def test_shift
    assert_same(@todos[0], @list.shift) && assert_equal(2, @list.size)
  end

  def test_pop
    assert_equal(@todos[2], @list.pop) && assert_equal(2, @list.size) # setup is rerun for each step, so previous test
    # doesn't affect the size of the array the instance variable @todos points to that's an attribute of the @list ToDoList object
  end

  def test_done?
    assert_equal(false, @list.done?)
  end

  def test_type_error_is_raised
    assert_raises(TypeError) { @list.add("Random String") }
  end

  def test_item_at
    assert_same(@todos[0], @list.item_at(0))
    assert_raises(IndexError) { @list.item_at(500) }
  end

  def test_mark_done_at
    3.times { |idx| @list.mark_done_at(idx) }
    assert_equal(true, @list.done?)
    assert_raises(IndexError) { @list.mark_done_at(500) }
  end

  def test_mark_undone_at
    assert_equal(false, @list.done?)
    assert_raises(IndexError) { @list.mark_undone_at(500) }
  end

  def test_done!
    @list.done!
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    assert_equal(@todos[0], @list.remove_at(0))
    assert_raises(IndexError) { @list.remove_at(500) }
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_to_s_for_partially_completed_list
    @list.first.done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_to_s_for_completed_list
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    @list.done!
    assert_equal(output, @list.to_s)
  end

  def test_each_is_iterative
    counts = 0
    @list.each { |_| counts += 1 }
    assert_equal(3, counts)
  end

  def test_each_return_value
    assert_same(@list, @list.each { |_| 1} )
  end

  def test_select
    still_to_do = @list.select do |todo|
      todo.done? == false # should select all todos b/c none are done
    end
    assert_equal(@list.todos, still_to_do.todos)
  end

  def test_add_alias_does_add_ToDo_object_to_list
    @list << ToDo.new("Take Out Recycling")
    refute_nil(@list.todos[3])
    assert_equal("Take Out Recycling", @list.last.title)
  end

  def test_find_by_title
    assert_same(@todos[0], @list.find_by_title("Buy milk"))
  end

  def test_current_list
    expected = @todos.map { |todo| todo.to_s }
    assert_equal(expected, @list.current_list)
  end

  def test_all_done
    @list_copy = @list.clone
    @list_copy.todos = []
    assert_equal(@list_copy.todos, @list.all_done.todos)
    assert_instance_of(ToDoList, @list.all_done)
  end

  def test_all_not_done
    assert_equal(@todos, @list.all_not_done.todos)
    assert_instance_of(ToDoList, @list.all_not_done)
  end

  def test_getter_methods
    assert_equal("Today's Todos", @list.title)
    assert_equal(@todos, @list.todos)
  end

  def test_setter_methods
    @list.title = "ToDos"
    @list.todos = []
    assert_equal("ToDos", @list.title)
    assert_equal([], @list.todos)
  end
end