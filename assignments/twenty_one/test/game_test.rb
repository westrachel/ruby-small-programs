ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'rack/test'
require 'fileutils'

require_relative '../game.rb'

class GameOf21Test < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    FileUtils.mkdir_p(datapath)
  end

  def session
    last_request.env["rack.session"]
  end

  def logged_in_session
    { "rack.session" => { username: "test", password: "test" } }
  end

  def test_logged_out_redirect
    @current_num_games = current_gamelog.size
    get "/new/game"
    assert_equal 302, last_response.status
    assert_equal @current_num_games, current_gamelog.size
  end

  def test_new_game
    get "/new/game", {}, logged_in_session
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Initial cards were dealt! Current score:"
  end

  def test_hitting_and_staying
    post "/game/0/hit", {}, logged_in_session
    @game = find_game(0)
    @hand = @game.players[0].hand.size
    assert_operator @hand, :>, 2
    assert_equal 302, last_response.status

    post "/game/0/stay"
    assert_equal 302, last_response.status
    get "/game/0"
    assert_includes last_response.body, "You stayed! The Dealer drew "
  end

  def test_homepage
    get "/"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Leaderboard:"
    assert_includes last_response.body, "test"
    assert_includes last_response.body, "Dealer"
  end

end