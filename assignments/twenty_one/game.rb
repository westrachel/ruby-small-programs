require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require "yaml"
require "bcrypt"
require "./twenty_one.rb"
require 'pry'

configure do
  enable :sessions
  set :session_secret, 'notsupersecret'
end

def current_gamelog
  full_game_file_path = datapath + "/game_log.yml"
  YAML.load(File.read(full_game_file_path))
end

before do
  @games = current_gamelog
  player_objects = current_gamelog.map { |game| game[:game].players }.flatten
  @players = player_objects.map { |plyr| plyr.name }.uniq
end

def datapath
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data", __FILE__)
  else
    File.expand_path("../data", __FILE__)
  end
end

def all_users_info
  user_info_location = if ENV["RACK_ENV"] == "test"
                         File.expand_path("../test/users.yml", __FILE__)
                       else
                         File.expand_path("../data/users.yml", __FILE__)
                       end
  YAML.load_file(user_info_location)
end

def add_game_to_log!(new_info, current_location)
  game_file = current_location + "/game_log.yml"
  File.open(game_file, "w") { |file| file.write(new_info.to_yaml) }
end

def update_gamelog!(updated_game, id)
  recreated_games = current_gamelog.select do |game|
    game[:game_id] != id
  end

  recreated_games << hashify_game_for_storage(id, updated_game)

  file = datapath + "/game_log.yml"
  File.delete(file)
  
  add_game_to_log!(recreated_games, datapath)
end

helpers do
  def extract_suit(card)
    suit = card[0]
    suit[0..(suit.size - 2)]
  end

  def players_hand(game, player_index)
    game.players[player_index].hand
  end
  
  def ensure_card_order(hand)
    initial_cards = hand[0..1]
    cards_from_hitting = hand[2..-1]
    latest_hit_first_order = cards_from_hitting.reverse + initial_cards 
    hand.size == 2 ? hand : latest_hit_first_order
  end

  def extract_values(cards)
    cards.map do |suit_value_arr|
      suit_value_arr[1]
    end
  end

  def separate_face_cards(hand)
    extract_values(hand).partition { |value| value == value.to_i }
  end

  def separate_aces(values)
    values.partition { |value| value == "ace" }
  end

  def score(hand)
    values = separate_face_cards(hand)
    num_cards, aces, faces_non_aces = values[0], separate_aces(values[1])[0], separate_aces(values[1])[1]
    total = num_cards.reduce(0, :+)
    total += 10 * (faces_non_aces.size)
    aces.size.times do |_|
      total += (total > 12 ? 1 : 10)
    end
    total
  end

  def scores(players)
    players.each_with_object([]) do |plyr, arr|
      arr << "#{plyr.name}: #{score(plyr.hand)}"
    end
  end
end

def valid_user_info?(username, password)
  if all_users_info.key?(username)
    bcrypt_password = BCrypt::Password.new(all_users_info[username])
    bcrypt_password == password
  end
end

def hashify_game_for_storage(id, game_object)
  { game_id: id, game: game_object }
end

def logged_in?
  all_users_info.include?(session[:username])
end

def logged_out_redirect_display(msg)
  if logged_in? == false
    session[:msg] = msg
    redirect "/"
  end
end

def next_feasible_game_id(games)
  current_game_ids = games.map { |game| game[:game_id] }
  current_game_ids.empty? ? 0 : current_game_ids.max + 1
end

def all_ids
  current_gamelog.map { |game| game[:game_id] }
end

def find_game(id)
  if all_ids.include?(id) == false
    session[:message] = "The specified game was not found."
    redirect "/"
  else
    return current_gamelog.select { |game| game[:game_id] == id }[0][:game]
  end
end

def bust_or_score_msg(score, name="Dealer")
  name_suffix = name == "Dealer" ? "' s" : "r"
  case score
  when 2..21 then "#{name + name_suffix} score is: #{score}"
  else "#{name} busted! Game over"
  end
end

get "/" do
  erb :main
end

get "/new/game" do
  logged_out_redirect_display("You must be logged in to play Twenty One.")

  @game_id = next_feasible_game_id(@games)
  @game = Game.new(Deck.new, Participant.new(session[:username]), Participant.new("Dealer"))
  @game.deal_initial_cards
  
  @games << hashify_game_for_storage(@game_id, @game)
  add_game_to_log!(@games, datapath)

  msg_pt1 = "Initial cards were dealt! Current score: #{scores(@game.players)[0]} "
  msg_pt2 = "vs Dealer: ? Enter hit to draw another card."
  session[:message] = msg_pt1 + msg_pt2
  
  erb :play
end

get "/game/:game_id" do
  logged_out_redirect_display("You must be logged in to view Twenty One games.")

  @game_id = params[:game_id].to_i
  @game = find_game(@game_id)

  erb :play
end

post "/game/:game_id/hit" do
  @game_id = params[:game_id].to_i
  @game = find_game(@game_id)
  @user = @game.players[0]
  @user.hit!(@game.deck.cards)
  @game.find_players_scores
  @last_card = @game.card_str(@user.hand, -1)

  update_gamelog!(@game, @game_id)

  msg_pt1 = "You pulled the: #{@last_card}."
  msg_pt2 = bust_or_score_msg(score(@user.hand), "You")

  session[:message] = msg_pt1 + msg_pt2
  redirect "/game/#{@game_id}"
end

post "/game/:game_id/dealers_turn" do
  @game_id = params[:game_id].to_i
  erb :final_hands
end

post "/game/:game_id/stay" do
  @game_id = params[:game_id].to_i
  @game = find_game(@game_id)
  @dealer = @game.players[1]

  until score(@dealer.hand) >= 17
    @dealer.hit!(@game.deck.cards)
  end

  @game.find_players_scores

  update_gamelog!(@game, @game_id)

  num_drawn = @dealer.hand.size - 2
  cards_drawn = num_drawn == 1 ? "1 card. " : "#{num_drawn} cards."
  msg_pt1 = "You stayed! The Dealer drew #{cards_drawn} "
  msg_pt2 = bust_or_score_msg(score(@dealer.hand)) + ". "
  msg_pt3 = @game.find_winner == "tie" ? "It was a tie!" : @game.find_winner + " won!"
  
  session[:message] = msg_pt1 + msg_pt2 + msg_pt3
  redirect "/game/#{@game_id}"

  redirect "/game/#{@game_id}"
end

get "/users/login" do
  erb :login
end

post "/users/login" do
  username = params[:username]

  if valid_user_info?(username, params[:password])
    session[:username] = username
    session[:message] = "Welcome, #{username}!"
    redirect "/"
  else
    session[:message] = "Invalid login credentials."
    status 422
    erb :login
  end
end

post "/users/logout" do
  session.delete(:username)
  session[:message] = "Successful logout."
  redirect "/"
end
