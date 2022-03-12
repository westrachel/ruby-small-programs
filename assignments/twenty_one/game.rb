require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require "yaml"
require "bcrypt"
require "./twenty_one.rb"

configure do
  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :secret => 'notsosecret'
end

before do
  session[:games] ||= []
end

def all_users_info
  user_info_location = if ENV["RACK_ENV"] == "test"
                         File.expand_path("../test/users.yml", __FILE__)
                       else
                         File.expand_path("../data/users.yml", __FILE__)
                       end
  YAML.load_file(user_info_location)
end

helpers do
  def extract_suit(card)
    suit = card[0]
    suit[0..(suit.size - 2)]
  end

  def players_hand(game, player_index)
    game.players[player_index].hand
  end
end

def valid_user_info?(username, password)
  if all_users_info.key?(username)
    bcrypt_password = BCrypt::Password.new(all_users_info[username])
    bcrypt_password == password
  end
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

def find_game(games, id_in_scope)
  arr = games.select do |game|
    game[:game_id] == id_in_scope
  end
  arr[0][:game]
end

def find_game_pt2(games, id_in_scope)
  arr = games.select do |game|
    game[:game_id] == id_in_scope
  end
  arr
end

get "/" do
  erb :main
end

get "/new/game" do
  logged_out_redirect_display("You must be logged in to play Twenty One.")

  @game_id = next_feasible_game_id(session[:games])
  session[:games] << { game_id: @game_id, game: Game.new(Deck.new, Participant.new(session[:username]), Participant.new("Dealer"))}
  @game = find_game(session[:games], @game_id)
  @game.deal_initial_cards
  
  session[:message] = "Time to play! The initial cards dealt are shown below. Enter hit to draw another card."
  
  erb :play
end

get "/game/:game_id" do
  logged_out_redirect_display("You must be logged in to view Twenty One games.")

  @game = find_game(session[:games], params[:game_id])

  erb :play
end

post "/game/:game_id/hit" do
  @game = find_game(session[:games], params[:game_id])
  @user = @game.players[0]
  @user.hit!(@game.deck)
  @last_card = @game.card_str(@user.hand, (@user.hand.size - 1 ))
  
  redirect "/game/:game_id"
end

post "/game/:game_id/stay" do
  
  redirect "/game/:game_id"
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

post "/game/:game_id/delete" do
  @game_id = params[:game_id]
  
  if env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    redirect "/"
  else
    session[:games].reject! { |game| game[:game_id] == @game_id }
    session[:message] = "#{session[:games]}"
    #session[:message] = "Game #: #{@game_id} was successfully deleted."
    redirect "/"
  end
end
