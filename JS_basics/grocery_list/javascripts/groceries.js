document.addEventListener('DOMContentLoaded', function() {
  let form = document.querySelector("form");
  const findVal = (id) => document.getElementById(id).value;
  let groceryList = document.querySelector('#grocery-list');

  form.addEventListener('submit', event => {
    event.preventDefault();
    let name = findVal('name');
    let quantity = findVal('quantity') || "1";

    let item = document.createElement("li");
    item.append(`${quantity}: ${name}`);
    groceryList.append(item);

    form.reset();
  });
});

