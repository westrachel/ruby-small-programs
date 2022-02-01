require 'sinatra'
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @files = ["Begin", "Luck", "Wisdom"]
  @files.reverse! if params[:sort] == "descending"
  erb :main
end

get "/Wisdom" do
  @quote1 = File.read("public/fc.txt")
  erb :wisdom
end

get "/Luck" do
  @quote2 = File.read("public/luck.txt")
  erb :luck
end

get "/Begin" do
  @quote3 = File.read("public/just_start.txt")
  erb :begin
end
