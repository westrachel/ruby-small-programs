require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require "redcarpet"

configure do
  enable :sessions
  set :session_secret, 'notanactualsecret'
end

def render_markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(text)
end

def data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("test/data", __FILE__)
  else
    File.expand_path("data/", __FILE__)
  end
end

def file_content(location)
  content = File.read(location)
  case File.extname(location)
  when ".md"
    render_markdown(content)
  when ".txt"
    headers["Content-Type"] = "text/plain"
    content
  end
end

get "/" do
  @scrubbed_list_of_files = Dir.entries("data").select do |filename|
    [".", ".."].include?(filename) == false
  end
  erb :homepage
end

get "/:filename" do
  file_path = File.join(data_path, params[:filename])

  #if File.exist?("data/#{params[:filename]}")
  #  file_content("data/#{params[:filename]}")
  if File.exist?(file_path)
    file_content(file_path)
  else
    session[:msg] = "#{params[:filename]} does not exist."
    redirect "/"
  end
end

get "/:filename/edit" do
  #if File.exist?("data/#{params[:filename]}")
  #  @filename = params[:filename]

  file_path = File.join(data_path, params[:filename])

  if File.exist?(file_path)
    file_content(file_path)
    @file_content = File.read(file_path)
    erb :edit_file
  else
    session[:msg] = "#{params[:filename]} does not exist, so edits cannot occur."
    redirect "/"
  end
end

post "/:filename" do
  file_path = File.join(data_path, params[:filename])
  File.write(file_path, params[:content])
  #File.write("data/#{params[:filename]}", params[:new_file_content])

  session[:msg] = "#{params[:filename]} has been updated."
  redirect "/"
end