require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"

require_relative "database_persistence"

configure do
  enable :sessions
  set :session_secret, 'notanactualsecret'
  set :erb, :escape_html => true
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
end


helpers do
  def list_complete?(list)
    list[:num_todos] > 0 & list[:num_incomplete_todos] == 0
  end

  def list_class(list)
    "complete" if list_complete?(list)
  end

  def sort_todos(todos_list)
    complete_todos, incomplete_todos = todos_list.partition { |todo| todo[:completed] }
    (incomplete_todos + complete_todos).flatten
  end
end

before do
	@storage = DatabasePersistence.new(logger)
end

def load_list(id)
	list = @storage.find_list(id)
	return list if list
  
  session[:error] = "The specified list was not found."
  redirect "/lists"
end

get "/" do
  redirect "/lists"
end

#  view display of all lists
get "/lists" do
  @lists = @storage.todo_status_all_lists
  erb :lists, layout: :layout
end

# form to create a new list
get "/lists/new" do
  erb :new_list, layout: :layout
end

# view individual list
get "/lists/:id" do
  @list_id = params[:id].to_i
  @list = load_list(@list_id)
  @todos = @storage.all_todos_in_list(@list_id)

  erb :individual_list, layout: :layout
end

# Retrieve page to edit existing list
get "/lists/:id/edit" do
  @list_id = params[:id].to_i
  @list = load_list(@list_id)
  erb :edit_list, layout: :layout
end

# allow user to revise an existing list
post "/lists/:id" do
  @list_id = params[:id].to_i
  @list = load_list(@list_id)
  @list_name = params[:revised_list_name].strip
  
  error = list_name_as_error(@list_name)
  if error
    session[:error] = error
    erb :edit_list, layout: :layout
  else
    @storage.revise_list_name(@list_id, @list_name)
    session[:error] = "The list name has been revised."
    redirect "/lists/#{@list_id}"
  end
end

# Return nil if list name is valid; otherwise return error message
def list_name_as_error(name)
  if !(2..100).cover? name.size
    "List must be between 2 and 100 characters."
  elsif @storage.todo_status_all_lists.any? {|list| list[:name] == name }
    "List name must be unique."
  end
end

# create a new list
post "/lists" do
  @list_name = params[:list_name].strip

  error = list_name_as_error(@list_name)
  if error
    session[:error] = error
    erb :new_list, layout: :layout
  else
    @storage.add_new_list(@list_name)

    session[:success] = "The list has been created."
    redirect "/lists"
  end
end

# delete a todo list
post "/lists/:id/delete" do
  @list_id = params[:id].to_i
  @list_name = @storage.find_list(@list_id)[:name]

  @storage.delete_list(@list_id)

  if env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    "/lists"
  else
    session[:success] = "The list, '#{@list_name}', has been deleted."
    redirect "/lists"
  end
end

def valid_todo_name?(name)
  if !(2..100).cover? name.size
    "Todo must be between 2 and 100 characters."
  end
end

# add todo items to a list
post "/lists/:list_id/todos" do
  @list_id = params[:list_id].to_i
  @list = load_list(@list_id)
  todo_name = params[:todo].strip
  
  error = valid_todo_name?(todo_name)
  if error
    session[:error] = error
    erb :edit_list, layout: :layout
  else
    @storage.create_new_todo(@list_id, todo_name)

    session[:success] = "The todo was added."
    redirect "/lists/#{@list_id}"
  end
end

# delete a todo item from a list
post "/lists/:list_id/todos/:todo_id/delete" do
  @list_id = params[:list_id].to_i
  @list = load_list(@list_id)
  @todo_id = params[:todo_id].to_i

  @storage.delete_todo_from_list(@todo_id)
  
  if env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    status 204 
  else
    session[:success] = "The todo has been deleted."
    redirect "/lists/#{@list_id}"
  end
end

# update a todo item as completed or not completed
post "/lists/:list_id/todos/:todo_id" do
  @list_id = params[:list_id].to_i
  @list = load_list(@list_id)
  @todo_id = params[:todo_id].to_i

  completeness = params[:completed]
  @storage.update_todo_status(@list_id, @todo_id, completeness)

  session[:success] = "The todo has been updated."
  redirect "/lists/#{@list_id}"
end

# complete all todo items at once for an individual list
post "/lists/:id/complete_all" do
  @list_id = params[:id].to_i
  @list = load_list(@list_id)

  @storage.mark_all_todos_complete(@list_id)

  session[:success] = "All todos have been completed."
  redirect "/lists/#{@list_id}"

end
