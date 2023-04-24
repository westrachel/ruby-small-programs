// Problem: Build out the following system
//  System is composed of:
//    > item creator
//         > ensures all necessary info is present + valid
//    > item manager
//         > creates items, updates info about items, deletes items, & queries info about items
//    > reports manager
//         > creates reports for one or all items
//         > reports for specific items are generated from report objects created from the report manager

// Item characteristics:
//  > SKU code: unique product identifier: first 3 letters of the item name & the first 2 letters of the category
//      > item names can be multiple words
//      > if the item name consists of 2 words & the 1st word consists of 2 letters only, the next letter is
//         taken from the next word
//  > Item name: This is the name of the item
//      > must have >= 5 characters
//      > Spaces are not counted as characters.
//  > Category: category that the item belongs to
//      >  must have >= 5 characters
//      > should only be 1 word
//  > Quantity: quantity in stock of an item
//      > must not be blank

// Properties/Behaviors of the item manager:
// i. create: creates a new item. Returns false if creation is not successful.
// ii. update: accepts an SKU Code and an object as an argument & updates info
//       on an item. Can assume valid values
// iii. delete: takes an SKU Code and deletes the item from the list
//      >> can assume a valid SKU code is provided.
// iv. items: list of all the items
// v. inStock: lists all the items that have a quantity greater than 0
// vi. itemsInCategory: lists all the items for a given category

// Behaviors of reports manager:
// i. init: This method accepts the ItemManager object as an argument and assigns it to the items property.
// ii. createReporter: This method accepts an SKU code as an argument and returns an object.
//    The returned object has one method, itemInfo. It logs to the console all the properties of an
//    object as "key:value" pairs (one pair per line). There are no other properties or methods on the
//    returned object (except for properties/methods inherited from Object.prototype).
// iii. reportInStock: Logs to the console the item names of all the items that are in stock as
//    comma separated values

let ItemCreator = (() => {
  function isNum(quantity) {
    return typeof quantity === "number";
  }
  
  function validCategory(str) {
    return str.match(/^[a-z]{5,}$/i);
  }

  function validItemNameLetters(str) {
    let chars = str.split('').filter((char) => char.match(/[a-z]/i));
    return chars.length >= 5 ? chars : false;
  }

  function createSKUId(item, category) {
    let code = validItemNameLetters(item).slice(0, 3).join('') + category.slice(0,2);
    return code.toUpperCase();
  }

  return function(item, category, quantity) {
   if (validItemNameLetters(item) && validCategory(category) && isNum(quantity)) {
    this.item = item;
    this.category = category;
    this.quantity = quantity;
    this.skuCode = createSKUId(item, category);
   } else {
     return { notValid: true };
   }
  };

})();

let ItemManager = {
  items: [],
  
  create(item, category, quantity) {
    let product = new ItemCreator(item, category, quantity);
    if (product.notValid) {
      return false;
    } else {
      this.items.push(product);
    }
  },

  findItem(sku) {
    return this.items.filter((obj) => obj.skuCode === sku.toUpperCase())[0];
  },
  
  update(sku, obj) {
    let product = this.findItem(sku);

    Object.keys(obj).forEach((key) => {
      if (Object.keys(product).includes(key)) {
        product[key] = obj[key];
      }
    });
  },
  
  delete(sku) {
    let itemToRemove = this.findItem(sku);
    this.items.splice(this.items.indexOf(itemToRemove), 1);
  },

  inStock() {
    return this.items.filter((item) => item.quantity > 0);
  },

  itemsInCategory(category) {
    return this.items.filter((item) => item.category === category);
  }
};

let ReportManager = {
  init(itemManager) {
    this.items = itemManager;
  },

  createReporter(sku) {
    let item = this.items.findItem(sku);

    return {
      itemInfo() {
        Object.keys(item).forEach((property) => {
          console.log(`${property}: ${item[property]}`);
        });
      }
    };
  },

  reportInStock(){
    console.log(this.items.inStock().map((obj) => obj.item).join(', '));
  }
};



ItemManager.create('basket ball', 'sports', 0); 
console.log(ItemManager.create('asd', 'sports', 0) === false);   // true; invalid item
ItemManager.create('soccer ball', 'sports', 5);                
console.log(ItemManager.create('football', 'sports') === false); // true; invalid item
ItemManager.create('football', 'sports', 3);           
console.log(ItemManager.create('kitchen pot', 'cooking items', 0) === false);  // true; invalid item
ItemManager.create('kitchen pot', 'cooking', 3);          
console.log(ItemManager.items);   //  4 items in the items array

ReportManager.init(ItemManager);
ReportManager.reportInStock(); // logs soccer ball, football, kitchen pot

ItemManager.update('SOCSP', { quantity: 0 });
console.log(ItemManager.inStock());
// logs list with the item objects for football and kitchen pot

ReportManager.reportInStock(); // logs football, kitchen pot

console.log(ItemManager.itemsInCategory('sports'));
// returns list with the item objects for basket ball, soccer ball, and football

ItemManager.delete('SOCSP');
console.log(ItemManager.items);
// soccer ball is no longer in the list

const kitchenPotReporter = ReportManager.createReporter('KITCO');
kitchenPotReporter.itemInfo();
// logs
// skuCode: KITCO
// itemName: kitchen pot
// category: cooking
// quantity: 3

ItemManager.update('KITCO', { quantity: 10 });
kitchenPotReporter.itemInfo();
// logs
// skuCode: KITCO
// itemName: kitchen pot
// category: cooking
// quantity: 10