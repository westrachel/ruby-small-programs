require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
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

# view individual list
get "/lists/:id" do
  @list_index = params[:id].to_i
  @lists = session[:lists]
  @selected_list = @lists[@list_index]

  erb :individual_list, layout: :layout
end

# Retrieve page to edit existing list
get "/lists/:id/edit" do
  list_index = params[:id].to_i
  @list = session[:lists][list_index]
  erb :edit_list, layout: :layout
end

# allow user to revise an existing list
post "/lists/:id" do
  list_name = params[:list_name].strip
  index = params[:id].to_i
  @list = session[:lists][index]
  
  error = list_name_as_error(list_name)
  if error
    session[:error] = error
    erb :edit_list, layout: :layout
  else
    @list[:name] = list_name
    session[:success] = "The list name has been revised."
    redirect "/lists/#{index}>"
  end
end


# Return nil if list name is valid; otherwise return error message
def list_name_as_error(name)
  if !(2..100).cover? name.size
    "List must be between 2 and 100 characters."
  elsif session[:lists].any? {|list| list[:name] == name }
    "List name must be unique."
  end
end


# create a new list
post "/lists" do
  list_name = params[:list_name].strip

  error = list_name_as_error(list_name)
  if error
    session[:error] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << {name: list_name, todos: []}
    session[:success] = "The list has been created."
    redirect "/lists"
  end
end
