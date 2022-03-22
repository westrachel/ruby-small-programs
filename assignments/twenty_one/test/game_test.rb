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

  #def teardown
  #  FileUtils.rm_rf(datapath)
  #end

  def session
    last_request.env["rack.session"]
  end

  def logged_in_session
    { "rack.session" => { username: "test", password: "test" } }
  end

  def test_logged_out_redirect
    get "/new/game"
    assert_equal 302, last_response.status
  end
  
end