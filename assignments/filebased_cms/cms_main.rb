require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require "redcarpet"
require "yaml"
require "bcrypt"

configure do
  enable :sessions
  set :session_secret, 'notanactualsecret'
end

def data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data", __FILE__)
  else
    File.expand_path("../data/", __FILE__)
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

def valid_user_info?(username, password)
  if all_users_info.key?(username)
    bcrypt_password = BCrypt::Password.new(all_users_info[username])
    bcrypt_password == password
  end
end

def create_file(name, content="")
  File.open(File.join(data_path, name), "w") do |file|
    file.write(content)
  end
end

def render_markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(text)
end

def file_content(location)
  content = File.read(location)
  case File.extname(location)
  when ".md"
    erb render_markdown(content)
  when ".txt"
    headers["Content-Type"] = "text/plain"
    content
  when ""
  end
end

def blank_filename?(filename)
  filename.match(/\S/).nil?
end

def ensure_extension(filename)
  File.extname(filename) == "" ? (filename + ".txt") : filename
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

get "/" do
  @scrubbed_list_of_files = Dir.entries("data").select do |filename|
    [".", ".."].include?(filename) == false
  end
  erb :homepage
end

get "/new" do
  logged_out_redirect_display("You must be logged in to create a new file.")
  
  erb :new_file
end

post "/new" do
  logged_out_redirect_display("You must be logged in to create a new file.")

  @new_filename = params[:new_file]
  
  if blank_filename?(@new_filename)
    session[:msg] = "A name is required to create a new file."
    erb :new_file
  elsif File.exist?(File.join(data_path, @new_filename))
    session[:msg] = "A unique name is required to create a new file."
    erb :new_file
  else
    @filename = ensure_extension(@new_filename)
    
    create_file(@filename)
    session[:msg] = "#{@filename} was created."
    redirect "/"
  end
end

get "/:filename" do
  file_path = File.join(data_path, File.basename(params[:filename]))

  if File.exist?(file_path)
    file_content(file_path)
  else
    session[:msg] = "#{params[:filename]} does not exist."
    redirect "/"
  end
end

get "/:filename/edit" do
  logged_out_redirect_display("You must be logged in to edit a file.")
  
  @filename = params[:filename]
  file_path = File.join(data_path, @filename)
  
  @file_content = File.read(file_path)
  erb :edit_file
end

post "/:filename" do
  logged_out_redirect_display("You must be logged in to create a file.")

  file_path = File.join(data_path, params[:filename])
  File.write(file_path, params[:new_file_content])

  session[:msg] = "#{params[:filename]} has been updated."
  redirect "/"
end

post "/:filename/delete" do
  logged_out_redirect_display("You must be logged in to delete a file.")

  file_path = File.join(data_path, params[:filename])
  File.delete(file_path)
  
  session[:msg] = "#{params[:filename]} was deleted."
  redirect "/"
end

post "/:filename/duplicate" do
  logged_out_redirect_display("You must be logged in to duplicate a file.")

  file_path = File.join(data_path, params[:filename])
  content = file_content(file_path)
  file_ext = File.extname(params[:filename])

  dups_filename = params[:filename].gsub(file_ext, "") + "_copy" + file_ext
  dups_file_path = File.join(data_path, dups_filename)
  File.write(dups_file_path, content)

  session[:msg] = "A copy of #{params[:filename]} was created."
  redirect "/"
end

get "/:filename/rename" do
  logged_out_redirect_display("You must be logged in to rename a file.")
  
  @filename = params[:filename]
  file_path = File.join(data_path, @filename)
  
  @file_content = File.read(file_path)
  erb :rename_file
end

post "/:filename/rename" do
  current_filename = params[:filename]
  new_filename = ensure_extension(params[:new_filename])
  
  current_file_path = File.join(data_path, current_filename)
  new_file_path = File.join(data_path, new_filename)
  
  File.rename(current_file_path, new_file_path)

  session[:msg] = "#{current_filename} was renamed to: #{new_filename}."
  redirect "/"
end

get "/users/login" do
  erb :login
end

post "/users/login" do
  username = params[:username]

  if valid_user_info?(username, params[:password])
    session[:username] = username
    session[:msg] = "Welcome, #{username}"
    redirect "/"
  else
    session[:msg] = "Username or password was incorrect. Please try again."
    status 422
    erb :login
  end
end

post "/users/logout" do
  session.delete(:username)
  session[:msg] = "You have successfully logged out."
  redirect "/"
end