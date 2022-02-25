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
  if File.exist?("data/#{params[:filename]}")
    file_content("data/#{params[:filename]}")
  else
    session[:error] = "#{params[:filename]} does not exist."
    redirect "/"
  end
end

get "/:filename/edit" do
  if File.exist?("data/#{params[:filename]}")
    @filename = params[:filename]
    @file_content = File.read("data/#{@filename}")
    erb :edit_file
  else
    session[:error] = "#{params[:filename]} does not exist, so edits cannot occur."
    redirect "/"
  end
end

post "/:filename" do
  @filename = params[:filename]
  File.open("data/#{params[:filename]}", 'r+') { |file| file.puts session[:new_file_content] }

  session[:success] = "#{@filename} has been updated."
  redirect "/#{@filename } "
end