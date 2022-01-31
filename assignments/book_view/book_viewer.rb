require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do  # assign a route to the "/" URL
  #File.read "public/template.html"  # Sinatra executes the body of this block & the return value is sent to the user's browser
  @title = "The Adventures of Sherlock Holmes"
  @table_of_contents = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1"
  @table_of_contents = File.readlines("data/toc.txt")
  @chapter_1 = File.read("data/chp1.txt")

  erb :chapter
end