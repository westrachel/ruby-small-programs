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
    assert_includes(last_response.body, "about.md")
    assert_includes(last_response.body, "changes.txt")
  end

  def test_history_file
    get "/history.txt"
    assert_equal 200, last_response.status
    assert_equal "text/plain", last_response["Content-Type"]
    assert_includes(last_response.body, "2007 - Ruby 1.9 released.\n")
  end

  def test_nonexistent_pg
    get "/nonexistent_page.txt"

    # user should be redirected when attempting to access nonexistent file
    assert_equal 302, last_response.status

    # get the page user was redirected to
    get last_response["Location"]

    assert_equal 200, last_response.status
    assert_includes(last_response.body, "nonexistent_page.txt does not exist.")

    # verify that after refreshing the homepage that the error message disappears
    get "/"
    refute_includes(last_response.body, "nonexistent_page.txt does not exist.")
  end

  def test_markdown_rendering
    get "/about.md"

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "<p>A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write.</p>"
  end
end