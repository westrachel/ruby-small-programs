class Deck
  SUITS = %w(clubs diamonds hearts spades)
  CARDS = (1..10).to_a + %w(jack queen king ace)
  FACE_CARD_VALUES = { "jack" => 10,
                       "queen" => 10,
                       "king" => 10,
                       "ace" => [10, 1] }

  attr_accessor :cards

  def initialize
    @cards = SUITS.each_with_object({}) do |suit, deck_hash|
      deck_hash[suit] = CARDS
    end
  end
end

class Participant
  attr_reader :name, :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def hit!(deck)
    suit = Deck::SUITS.sample
    @hand << [suit, deck[suit].delete(deck[suit].sample) ]
  end
end

class Game
  attr_accessor :deck
  attr_reader :players, :winner

  def initialize(deck, player, dealer)
    @players = [player, dealer]
    @deck = deck
    @winner = ""
  end

  def breakline
    puts ""
  end

  def begin
    1.times do |_|
      deal_initial_cards
      initial_card_display
      initial_score_display
      player_moves
      break if busted?(@players[0])
      dealer_moves
      break if busted?(@players[1])
      display_score
    end
    msg_if_bust_found
  end

  def find_winning_plyr_index(scores)
    diffs = scores.map { |num| 21 - num }
    abs_diffs = diffs.map do |diff|
      multiplier = (diff < 0 ?  -1 : 1)
      diff * multiplier
    end
    return [0, 1] if abs_diffs.uniq.size == 1
    index_of_winner = abs_diffs.index(abs_diffs.min)
    index_of_winner
  end

  def bust_winner_or_nil
    bust_winner = nil
    @players.each_with_index do |plyr, idx|
      opponent_idx = (idx == 0 ? 1 : 0)
      bust_winner = @players[opponent_idx].name if busted?(plyr)
    end
    bust_winner
  end

  def plyr_scores_arr
    @players.each_with_object([]) do |plyr, arr|
      arr << calc_total(plyr.hand)
    end
  end

  def set_winner
    @winner = find_winner
  end

  def find_winner
    return bust_winner_or_nil if bust_winner_or_nil

    winner_idx = find_winning_plyr_index(plyr_scores_arr)
    if winner_idx == [0, 1]
      "tie"
    else
      @players[winner_idx].name
    end
  end

  def scores
    @players.each_with_object([]) do |plyr, arr|
      arr << "#{plyr.name}: #{calc_total(plyr.hand)}"
    end
  end

  def declare_winner_msg(winner)
    puts "The final score is:"
    scores.each { |name_score| puts name_score }
    puts "#{winner.name} won!"
  end

  def display_score
    x1 = @players[0]
    x2 = @players[1]
    case find_winner
    when x1.name
      declare_winner_msg(x1, x2)
    when x2.name
      declare_winner_msg(x2, x1)
    when "tie"
      "It was a tie!"
    end
  end

  def opponent_of(current_player)
    if current_player.name == @players[0].name
      @players[1].name
    else
      @players[0].name
    end
  end

  def msg_if_bust_found
    msg = ""
    # game loop breaks if the non-dealer busts, so player must be first in @players array
    @players.each do |plyr|
      if busted?(plyr)
        msg = "#{plyr.name} busted! #{opponent_of(plyr)} wins!"
      end
    end
    puts msg
  end

  def dealer_moves
    dealer = @players[1]
    until calc_total(dealer.hand) >= 17
      dealer.hit!(@deck.cards)
    end
  end

  def deal_initial_cards
    @players.each do |player|
      2.times { |_| player.hit!(@deck.cards) }
    end
  end

  def card_str(hand, card_index)
    "#{hand[card_index][1]} of #{hand[card_index][0]}"
  end

  def dealer_hand_initial_display
    puts "#{@players[1].name} was dealt:"
    puts ">" + card_str(@players[1].hand, 0)
    puts "> unknown card"
    breakline
  end

  def initial_card_display
    player = @players[0]
    puts "#{player.name} was dealt:"
    [0, 1].each { |card_idx| puts card_str(player.hand, card_idx) }
    breakline
    dealer_hand_initial_display
  end

  def initial_score_display
    puts "The current score is:"
    puts ">> #{@players[0].name}: #{calc_total(@players[0].hand)}"
    puts ">> #{@players[1].name} has an unknown total"
  end

  def extract_values(hand)
    hand.map do |suit_value_card_arr|
      suit_value_card_arr[1]
    end
  end

  def separate_face_cards(hand)
    extract_values(hand).partition { |value| value == value.to_i }
  end

  def separate_aces(values)
    values.partition { |value| value == "ace" }
  end

  def calc_total(hand)
    values = separate_face_cards(hand)
    num_cards, aces, faces_non_aces = values[0], separate_aces(values[1])[0], separate_aces(values[1])[1]
    total = num_cards.reduce(0, :+)
    total += 10 * (faces_non_aces.size)
    aces.size.times do |_|
      total += (total > 12 ? 1 : 10)
    end
    total
  end

  def player_moves
    choice = ""
    player = @players[0]
    loop do
      puts "hit? (y to hit, n to stay)"
      choice = gets.chomp.downcase
      next if %w(y n).include?(choice) == false
      break if choice == "n"
      player.hit!(@deck.cards)
      puts "#{player.name} was dealt:"
      puts card_str(player.hand, -1)
      puts "#{player.name}'s total score is: #{calc_total(player.hand)} "
      breakline
      break if busted?(player)
    end
  end

  def busted?(participant)
    calc_total(participant.hand) > 21
  end
end
