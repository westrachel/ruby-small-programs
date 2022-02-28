ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"
require 'fileutils'

require_relative '../cms_main'

class FileBasedCMSTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def setup
    FileUtils.mkdir_p(data_path)
  end

  def teardown
    FileUtils.rm_rf(data_path)
  end

  def test_homepage
    create_file "history.txt"
    create_file "changes.txt"
    create_file "about.md"

    get "/"

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "history.txt"
    assert_includes last_response.body, "about.md" 
    assert_includes last_response.body, "changes.txt"
  end

  def test_text_file_viewing
    create_file "history.txt", "1993 - Yukihiro Matsumoto dreams up Ruby."

    get "/history.txt"
    assert_equal 200, last_response.status
    assert_equal "text/plain", last_response["Content-Type"]
    assert_includes last_response.body, "1993 - Yukihiro Matsumoto dreams up Ruby."
  end

  def test_markdown_file_viewing
    create_file "about.md", "# Ruby is..."
    get "/about.md"

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "<h1>Ruby is...</h1>"
  end

  def test_nonexistent_pg
    get "/nonexistent_page.txt"

    # user should be redirected when attempting to access nonexistent file
    assert_equal 302, last_response.status

    # get the page user was redirected to
    get last_response["Location"]

    assert_equal 200, last_response.status
    assert_includes last_response.body, "nonexistent_page.txt does not exist."

    # verify that after refreshing the homepage that the error message disappears
    get "/"
    refute_includes last_response.body, "nonexistent_page.txt does not exist."
  end

  def test_edit_file
    create_file "about.md"

    get "/about.md/edit"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "<form"
    assert_includes last_response.body, "<textarea"
    assert_includes last_response.body, "<button type="
  end
  
  def test_saving_file_edits
    post "/changes.txt", new_file_content: "All files can be edited!"
    assert_equal 302, last_response.status

    get last_response["location"]

    assert_includes last_response.body, "changes.txt has been updated."
    get "/changes.txt"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "All files can be edited!"
  end

  def test_make_new_file_with_blank_name
    post "/new", new_file: ""
    assert_includes last_response.body, "A name is required to create a new file."
  end

  def test_make_new_files
    post "/new", new_file: "hello_world"
    assert_equal 302, last_response.status

    get last_response["location"]
    assert_includes last_response.body, "hello_world.txt was created."
  end

  def test_deleting_a_file
    post "/new", new_file: "test.txt"

    post "/test.txt/delete"
    get last_response["location"]
    assert_includes last_response.body, "test.txt was deleted."

    get "/"
    refute_includes last_response.body, "test.txt"
  end
end