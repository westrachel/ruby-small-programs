require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @table_of_contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(chpter_content)
    chpter_content.split("\n\n")
  end
end

get "/" do  # assign a route to the "/" URL
  #File.read "public/template.html"  # Sinatra executes the body of this block & the return value is sent to the user's browser
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  chp_number = params[:number].to_i
  chp_name = @table_of_contents[chp_number - 1]
  @title = "Chapter #{chp_number}: #{chp_name}"

  @chapter_contents = File.read("data/chp#{chp_number}.txt")

  erb :chapter
end
