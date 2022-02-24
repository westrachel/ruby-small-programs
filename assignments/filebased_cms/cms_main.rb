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