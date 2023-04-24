var inventory;

(function() {
  const select = (selector) => document.querySelector(selector);
  inventory = {
    lastId: 0,
    collection: [],
    setDate: function() {
      let date = new Date();
      select("#order_date").textContent = date.toUTCString();
    },
    cacheTemplate: function() {
      var iTmpl = select("#inventory_item");
      this.template = Handlebars.compile(iTmpl.innerHTML);
      iTmpl.remove();
    },
    add: function() {
      this.lastId++;
      let item = {
        id: this.lastId,
        name: "",
        stock_number: "",
        quantity: 1
      };
      this.collection.push(item);

      return item;
    },
    remove: function(idx) {
      this.collection = this.collection.filter(function(item) {
        return item.id !== idx;
      });
    },
    get: function(id) {
      let found_item;

      this.collection.forEach(function(item) {
        if (item.id === id) {
          found_item = item;
        }
      });

      return found_item;
    },
    update: function(row) {
      let id = this.findID(row);
      let item = this.get(id);

      item.name = row.querySelector("[name^=item_name]").value;
      item.stock_number = row.querySelector("[name^=item_stock_number]").value;
      item.quantity = row.querySelector("[name^=item_quantity]").value;
    },
    newItem: function(e) {
      e.preventDefault();
      let item = this.add();
      select("#inventory").insertAdjacentHTML('beforeend', this.template({ id: item.id }));
    },
    findParent: function(e) {
      return e.target.closest("tr");
    },
    findID: function(item) {
      return +item.querySelector("input[type=hidden]").value;
    },
    deleteItem: function(e) {
      e.preventDefault();
      if(e.target.classList.contains('delete')) {
        let item = this.findParent(e);
        this.remove(this.findID(item));
        item.remove();
      }
    },
    updateItem: function(e) {
      if (event.target.tagName === 'INPUT') {
        let item = this.findParent(e);
        this.update(item);
      }

    },
    bindEvents: function() {
      select('#add_item').addEventListener('click', this.newItem.bind(this));
      select('#inventory').addEventListener('click', this.deleteItem.bind(this));
      select('#inventory').addEventListener('focusout', this.updateItem.bind(this));
    },
    init: function() {
      this.setDate();
      this.cacheTemplate();
      this.bindEvents();
    }
  };
})();

document.addEventListener('DOMContentLoaded', e => inventory.init.bind(inventory)());