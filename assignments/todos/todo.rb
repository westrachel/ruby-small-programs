require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'notanactualsecret'
  set :erb, :escape_html => true
end

helpers do
  def list_complete?(list)
    total_todos(list) > 0 && count_incomplete_todos(list) == 0
  end

  def list_class(list)
    "complete" if list_complete?(list)
  end
  
  def count_incomplete_todos(list)
    list[:todos].select { |todo| todo[:completed] == false }.size
  end

  def total_todos(list)
    list[:todos].size
  end

  def sort_lists(lists, &block)
    complete_lists, incomplete_lists = lists.partition { |list| list_complete?(list) }

    incomplete_lists.each { |list| yield list, lists.index(list) }
    complete_lists.each { |list| yield list, lists.index(list) }
    
  end

  def sort_todos(todos_list, &block)
    complete_todos, incomplete_todos = todos_list.partition { |todo| todo[:completed] }

    incomplete_todos.each { |todo| yield todo, todos_list.index(todo) }
    complete_todos.each { |todo| yield todo, todos_list.index(todo) }
  end

end

before do
  session[:lists] ||= []
end

get "/" do
  redirect "/lists"
end

#  view display of all lists
get "/lists" do
  @lists = session[:lists]
  erb :lists, layout: :layout
end

# form to create a new list
get "/lists/new" do
  erb :new_list, layout: :layout
end

def find_list(id)
  largest_active_list_id = session[:lists].size - 1

  if largest_active_list_id < id
    session[:error] = "The specified list was not found."
    redirect "/lists"
  else
    return session[:lists][id]
  end
end

# view individual list
get "/lists/:id" do
  @list_id = params[:id].to_i

  @list = find_list(@list_id)
  erb :individual_list, layout: :layout
end

# Retrieve page to edit existing list
get "/lists/:id/edit" do
  @list_id = params[:id].to_i
  @list = find_list(@list_id)
  erb :edit_list, layout: :layout
end

# allow user to revise an existing list
post "/lists/:id" do
  @list_id = params[:id].to_i
  @list = find_list(@list_id)
  @list_name = params[:revised_list_name].strip
  
  error = list_name_as_error(@list_name)
  if error
    session[:error] = error
    erb :edit_list, layout: :layout
  else
    @list[:name] = @list_name
    session[:success] = "The list name has been revised."
    redirect "/lists/#{@list_id}"
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
  @list_name = params[:list_name].strip

  error = list_name_as_error(@list_name)
  if error
    session[:error] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << {name: @list_name, todos: []}
    session[:success] = "The list has been created."
    redirect "/lists"
  end
end

# delete a todo list
post "/lists/:id/delete" do
  @list_id = params[:id].to_i
  @list_name = session[:lists][@list_id][:name]
  session[:lists].delete_at(@list_id)

  if env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    "/lists"
  else
    session[:success] = "The list, '#{@list_name}', has been deleted."
    redirect "/lists"
  end
end

def todo_as_error(name)
  if !(2..100).cover? name.size
    "Todo must be between 2 and 100 characters."
  end
end

# add todo items to a list
post "/lists/:list_id/todos" do
  @list_id = params[:list_id].to_i
  @list = find_list(@list_id)
  todo_input = params[:todo].strip
  
  error = todo_as_error(todo_input)
  if error
    session[:error] = error
    erb :edit_list, layout: :layout
  else
    @list[:todos] << {name: params[:todo], completed: false}
    session[:success] = "The todo was added."
    redirect "/lists/#{@list_id}"
  end
end

# delete a todo item from a list
post "/lists/:list_id/todos/:todo_id/delete" do
  @list_id = params[:list_id].to_i
  @list = find_list(@list_id)
  @todo_id = params[:todo_id].to_i
  
  @list[:todos].delete_at(@todo_id)
  
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
  @list = find_list(@list_id)
  @todo_id = params[:todo_id].to_i
  
  is_complete_boolean = params[:completed] == "true"
  @list[:todos][@todo_id][:completed] = is_complete_boolean
  session[:success] = "The todo has been updated."
  redirect "/lists/#{@list_id}"
end

# complete all todo items at once for an individual list
post "/lists/:id/complete_all" do
  @list_id = params[:id].to_i
  @list = find_list(@list_id)
  
  @list[:todos].each do |todo|
    todo[:completed] = true
  end

  session[:success] = "All todos have been completed."
  redirect "/lists/#{@list_id}"

end