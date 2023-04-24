const TodoManager = (() => {
  let todo_items = [
    { id: 1, title: 'Homework' },
    { id: 2, title: 'Shopping' },
    { id: 3, title: 'Calling Mom' },
    { id: 4, title: 'Coffee with John '}
  ];
  
  return {
    addTodo(todo) {
      const template = document.querySelector('#todo_template').innerHTML;
      const renderTodoHTML = Handlebars.compile(template);
      document.querySelector('.todo_items').innerHTML += renderTodoHTML(todo);
    },
    
    init() {
      todo_items.forEach(this.addTodo);
      this.addDeleteTodoListener();
    },
    
    addDeleteTodoListener() {
      document.addEventListener('click', event => {
        const confirmed = confirm("Are you sure you want to delete this todo?");
        if (confirmed) {
          const parent = document.getElementById(event.target.id).closest('div');
          parent.classList.add('hide');
        }
      });
    }
  };
 
})();

document.addEventListener('DOMContentLoaded', event => {
  TodoManager.init();
});