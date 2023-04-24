require "pg"

class DatabasePersistence
	def initialize(tracker)
		@db = PG.connect(dbname: "todos")
		@logger = tracker
	end

	def query(sql_statement, *parameters)
		@logger.info "#{sql_statement}: #{parameters}"
		@db.exec_params(sql_statement, parameters)
	end

	def find_list(id)
		todo_status_all_lists.select { |list| list[:id] == id }[0]
	end

  def todo_status_all_lists
    selection = "SELECT lists.id, lists.name AS list_name,
                    COUNT(case todos.completed when FALSE then 1 else null end) AS count_incomplete_todos,
                    COUNT(todos.id) AS num_todos
                    FROM lists LEFT JOIN todos 
                      ON lists.id = todos.list_id
                    GROUP BY lists.name, lists.id
                    ORDER BY list_name;"
    result = query(selection)
    result.map do |tuple|
      { id: tuple["id"].to_i,
        name: tuple["list_name"],
        num_incomplete_todos: tuple["count_incomplete_todos"].to_i,
        num_todos: tuple["num_todos"].to_i }
    end
  end

  def add_new_list(name)
    query("INSERT INTO lists (name) VALUES ($1);", name)
  end

  def delete_list(list_id)
    query("DELETE FROM lists WHERE id = $1;", list_id)
  end

  def revise_list_name(id, new_name)
    query("UPDATE lists SET name = $1
              WHERE id = $2;", new_name, id)
  end

  def create_new_todo(list_id, todo_name)
    query("INSERT INTO todos (list_id, name)
                VALUES ($1, $2);", list_id, todo_name)
  end

  def delete_todo_from_list(todo_id)
    query("DELETE FROM todos WHERE id = $1;", todo_id)
  end

  def mark_all_todos_complete(list_id)
    query("UPDATE todos SET completed = true 
                WHERE list_id = $1;", list_id)
  end

  def update_todo_status(list_id, todo_id, new_status)
    query("UPDATE todos SET completed = $1
                WHERE list_id = $2 AND id = $3;",
          new_status, list_id, todo_id)
  end

  def all_ids(list)
    list.map { |element| element[:id] }
  end

	def all_todos_in_list(list_id)
		sql = "SELECT * FROM todos WHERE list_id = $1;"
		result_todos = query(sql, list_id)
		result_todos.map do |tuple|
			{ id: tuple["id"].to_i,
			  name: tuple["name"],
			  completed: (tuple["completed"] == "t") }
		end
	end
end