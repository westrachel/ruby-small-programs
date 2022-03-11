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
  attr_accessor :current_score

  def initialize(name)
    @name = name
    @hand = []
    @current_score = 0
  end

  def hit!(deck)
    suit = Deck::SUITS.sample
    @hand << [suit, deck[suit].delete(deck[suit].sample) ]
  end
end

class Game
  attr_accessor :deck
  attr_reader :player

  def initialize(deck, player, dealer)
    @players = [player, dealer]
    @deck = deck
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

  def find_winner
    x1_score = calc_total(@players[0].hand)
    x2_score = calc_total(@players[1].hand)
    if x1_score < x2_score
      @players[0].name
    elsif x1_score > x2_score
      @players[1].name
    else
      "tie"
    end
  end

  def declare_winner_msg(winner, loser)
    puts "The final score is:"
    puts "#{winner.name}: #{calc_total(winner.hand)}"
    puts "#{loser.name}: #{calc_total(loser.hand)}"
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
    "> #{hand[card_index][1]} of #{hand[card_index][0]}"
  end

  def dealer_hand_initial_display
    puts "#{@players[1].name} was dealt:"
    puts card_str(@players[1].hand, 0)
    puts "> unknown card"
    breakline
  end

  def initial_card_display
    player = @players[0]
    puts "#{player.name} was dealt:"
    puts card_str(player.hand, 0)
    puts card_str(player.hand, 1)
    breakline
    dealer_hand_initial_display
  end

  def find_players_scores
    @players.each do |player|
      player.current_score = calc_total(player.hand)
    end
  end

  def initial_score_display
    find_players_scores
    puts "The current score is:"
    puts ">> #{@players[0].name}: #{@players[0].current_score}"
    puts ">> #{@players[1].name} has an unknown total"
  end

  def extract_values(hand)
    hand.map do |suit_value_card_arr|
      suit_value_card_arr[1]
    end
  end

  def calc_total(hand)
    values = extract_values(hand)
    total = 0
    values.each do |value|
      total += if value == "ace"
                 total < 12 ? 10 : 1
               elsif value.to_i == value
                 value
               else
                 Deck::FACE_CARD_VALUES[value]
               end
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
      puts card_str(player.hand, (player.hand.size - 1))
      puts "#{player.name}'s total score is: #{calc_total(player.hand)} "
      breakline
      break if busted?(player)
    end
  end

  def busted?(participant)
    calc_total(participant.hand) > 21
  end
end

#game1 = Game.new(Deck.new, Participant.new("player"), Participant.new("dealer"))
#game1.begin