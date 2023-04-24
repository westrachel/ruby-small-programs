require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

before do
  @users_interests = YAML.load_file("public/users.yaml")
  @footer_msg = "There are #{total_users} total users & #{total_unique_interests} total unique interests."
end

helpers do
  def total_users
    @users_interests.keys.size
  end

  def total_unique_interests
    interests = @users_interests.values.each_with_object([]) do |subhash, arr|
      arr << subhash[:interests]
    end.flatten
    interests.uniq.size
  end
end

get "/" do
  @users = @users_interests.keys.map do |username_symbol|
    username_symbol.to_s
  end

  erb :main
end

get "/users/:name" do
  @username = params[:name] # this is a string
  @user_profile = @users_interests[@username.to_sym]
  
  @other_users = @users_interests.select do |name, profile|
    name != @username.to_sym
  end.keys

  erb :user
end