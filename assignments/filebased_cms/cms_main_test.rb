ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

require_relative 'cms_main'

class FileBasedCMSTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_homepage
    get "/"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes(last_response.body, "history.txt")
    assert_includes(last_response.body, "about.txt")
    assert_includes(last_response.body, "changes.txt")
  end

  def test_history_file
    get "/history.txt"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes(last_response.body, "2007 - Ruby 1.9 released.\n")
  end
end