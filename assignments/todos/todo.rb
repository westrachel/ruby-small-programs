require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'notanactualsecret'
end

before do
  session[:lists] ||= []
end

get "/" do
  redirect "/lists"
end

# current routes:
#  GET /lists           => showcase all existing lists
#  GET /lists/new       => new list form
#  POST /lists          => add a new list
#  GET /lists/:id       => view individual list

#  view display of all lists
get "/lists" do
  @lists = session[:lists]
  erb :lists, layout: :layout
end

# form to create a new list
get "/lists/new" do
  erb :new_list, layout: :layout
end

# create a new list
post "/lists" do
  session[:lists] << {name: params[:list_name], todos: []}
  redirect "/lists"
end