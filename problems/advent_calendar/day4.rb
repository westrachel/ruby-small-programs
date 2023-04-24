# Problem:
# Create a program to mimic your submarine and a squid playing Bingo

# Bingo Requirements:
# > board is a 5x5 grid of integers that are all randomly chosen
# > 3 boards are generated in a game
# > max allowable number in a board is not given, so I'll assume the
#      max number is 99
# > all numbers in a board are unique
# > first winner is the board to have all numbers in a row or column
#     selected
# > the score of a winner should be calculated as the sum of the
#    numbers in the winning row, column, or diagonal times the last
#    number called before there was a winner

class BingoBoard
  attr_accessor :board
  attr_reader :board_id

  NUMBERS = (0..99).to_a
  NAMES = ['spock', 'R2D2', 'dory', 'yoda', 'shrek']
  @@number_of_boards = 0

  def initialize
    @board = []
    create_board!
    @board_id = NAMES.sample + "_#" + @@number_of_boards.to_s
    @@number_of_boards += 1
  end

  def create_board!
    5.times do |_|
      row = []
      until row.size == 5
        a_sample = NUMBERS.sample
        row << a_sample if row.include?(a_sample) == false
      end
      @board << row
    end
  end

  def column_values
    @board.each_with_object({}) do |row_array, hash|
      row_array.size.times do |index|
        if hash.include?(index) == false
          hash[index] = [row_array[index]]
        else
          hash[index] << row_array[index]
        end
      end
    end
  end

  def diagonal_values
    hsh = { first_corner_diagonal: [],
            second_corner_diagonal: [] }
    5.times do |index|
      @board.each { |row| hsh[:first_corner_diagonal] << row[index] }
    end
    5.times do |idx|
      @board.each { |row| hsh[:second_corner_diagonal] << row[(5 - idx)] }
    end
    hsh
  end
end

class BingoGame
  attr_reader :boards

  def initialize
    @boards = []
    @selected_nums = []
    @available_nums = (0..99).to_a
    @winner = nil
    @winning_nums = []
  end

  def add_players(number)
    number.times do |_|
      @boards << BingoBoard.new
    end
  end

  def play
    call_out_numbers(5)
    until winner? || @available_nums.empty?
      sample_numbers(1)
    end
    puts "The #s: #{extra_draws}, & #{last_draw} were drawn to find a winner."
    display_winner_message
  end

  def extra_draws
    @selected_nums[5..(@selected_nums.size - 2)].join(', ')
  end

  def last_draw
    @selected_nums.last
  end

  def call_out_numbers(amount_of_numbers)
    nums = sample_numbers(amount_of_numbers)
    list = nums[0..(nums.size - 2)].join(', ')
    puts "Initial numbers drawn were: #{list}, & #{nums.last}."
  end

  def sample_numbers(amount_of_numbers)
    array_sample = []
    amount_of_numbers.times do |_|
      a_sample = @available_nums.sample
      @selected_nums << a_sample
      array_sample << a_sample
      @available_nums.delete(a_sample)
    end
    array_sample
  end

  def winner?
    row_winner? || column_winner? || diagonal_winner?
  end

  def row_winner?
    any_full_match = false
    @boards.each do |game_board|
      game_board.board.each do |row_values|
        any_full_match = true if winning_5?(row_values)
        @winner = game_board if any_full_match
        break if any_full_match
      end
      break if any_full_match
    end
    any_full_match
  end

  def column_winner?
    any_full_match = false
    @boards.each do |game_board|
      game_board.column_values.each do |_, column_values|
        any_full_match = true if winning_5?(column_values)
        @winner = game_board if any_full_match
        break if any_full_match
      end
      break if any_full_match
    end
    any_full_match
  end

  def diagonal_winner?
    any_full_match = false
    @boards.each do |board|
      board.diagonal_values.each do |_, diagonal_values|
        any_full_match = true if winning_5?(diagonal_values)
        @winner = game_board if any_full_match
        break if any_full_match
      end
      break if any_full_match
    end
    any_full_match
  end

  def winning_5?(array)
    @winning_nums = array if array.all? { |num| @selected_nums.include?(num) }
  end

  def display_winner_message
    puts "#{@winner.board_id} won with a score of #{winning_score}!"
  end

  def winning_score
    @winning_nums.sum * @selected_nums.last
  end
end

game1 = BingoGame.new
game1.add_players(3)
game1.play
