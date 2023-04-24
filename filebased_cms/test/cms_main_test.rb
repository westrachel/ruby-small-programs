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

  def session
    last_request.env["rack.session"]
  end

  def logged_in_session
    { "rack.session" => { username: "user1", password: "notsosecret"} }
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
    assert_equal 302, last_response.status
    assert_equal "nonexistent_page.txt does not exist.", session[:msg]
  end

  def test_edit_file
    create_file "about.md"

    get "/about.md/edit", {}, logged_in_session

    assert_equal 200, last_response.status
    assert_includes last_response.body, "<form"
    assert_includes last_response.body, "<textarea"
    assert_includes last_response.body, "<button type="
  end
  
  def test_saving_file_edits
    get "/new", {}, logged_in_session
    post "/changes.txt", new_file_content: "All files can be edited!"
    assert_equal 302, last_response.status
    assert_equal "changes.txt has been updated.", session[:msg]

    get "/changes.txt"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "All files can be edited!"
  end

  def logged_in_session
    { "rack.session" => { username: "user1", password: "notsosecret"} }
  end

  def test_make_new_file_with_blank_name
    get "/new", {}, logged_in_session
    post "/new", new_file: ""
    assert_includes last_response.body, "A name is required to create a new file."
  end

  def test_make_new_files
    get "/new", {}, logged_in_session
    post "/new", new_file: "hello_world"
    assert_equal 302, last_response.status
    assert_equal "hello_world.txt was created.", session[:msg]

    get "/"
    assert_includes last_response.body, "hello_world.txt"
  end

  def test_deleting_a_file
    get "/new", {}, logged_in_session
    post "/new", new_file: "test.txt"

    post "/test.txt/delete"
    assert_includes "test.txt was deleted.", session[:msg]

    get "/"
    refute_includes last_response.body, %q(href="/test.txt")
  end

  def test_duplicating_and_renaming_file
    get "/new", {}, logged_in_session
    post "/new", new_file: "test.txt"

    post "/test.txt/duplicate"
    get last_response["location"]
    assert_includes last_response.body, %q(href="/test_copy.txt")

    post "/test_copy.txt/rename", new_filename: "answer.txt"
    assert_includes "test_copy.txt was renamed to: answer.txt.", session[:msg]

    get "/"
    assert_includes last_response.body, %q(href="/answer.txt")
  end

  def test_incorrect_login
    post "/users/login", username: "user2", password: ""
    assert_equal 422, last_response.status
    assert_nil session[:username]
    assert_includes last_response.body, "Username or password was incorrect. Please try again."
  end

  def test_succesful_login_logout
    post "/users/login", username: "user1", password: "notsosecret"
    assert_equal 302, last_response.status
    assert_equal "Welcome, user1", session[:msg]

    post "users/logout"
    get last_response["location"]
    assert_includes last_response.body, "You have successfully logged out."
    assert_includes last_response.body, "Login"
  end

  def test_actions_unsuccessful_while_signed_out
    get "/new"
    assert_includes "You must be logged in to create a new file.", session[:msg]
    
    get "/new", {}, logged_in_session
    post "/new_file.ext", new_file_content: ""
    post "users/logout"
    
    get "/new_file.ext/edit"
    # user should be redirected to homepage that lists out new_file.ext and has temporary session message
    assert_includes "You must be logged in to edit a file.", session[:msg]
    get last_response["location"]
    assert_includes last_response.body, "new_file.ext"

    post "/new_file.ext/duplicate"
    assert_includes "You must be logged in to duplicate a file.", session[:msg]
    
    post "/new_file.ext/delete"
    assert_includes "You must be logged in to delete a file.", session[:msg]
  end
end