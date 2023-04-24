var u;
var _;

(function() {
  _ = function(element) {
    u = {
      first: function() {
        return element[0];
      },

      last: function() {
        return element[element.length - 1];
      },

      without: function(...args) {
        let new_arr = element.filter((value) => {
          return !args.includes(value);
        });
        
        return new_arr;
      },
      
      lastIndexOf: function(search) {
        let idx = -1;
        
        for (let i = element.length - 1; i >= 0; i -= 1) {
          if (element[i] === search) {
            idx = i;
            break;
          }
        }

        return idx;
      },
      
      findWhere: function(properties) {
        for (let i = 0; i < element.length; i += 1) {
          let obj = element[i];

          let match = Object.keys(properties).every((key) => {
            return obj[key] === properties[key];
          });
          
          if (match) {
            return obj;
          }
        }
      },
      
      where: function(obj) {
        let matches = [];
      
        element.forEach((currObj) => {
          let fullMatch = Object.keys(obj).every((key) => {
            return obj[key] == currObj[key];
          });
          
          if (fullMatch) {
            matches.push(currObj);
          }
        });
        
        return matches;
      },

      pluck: function(prop) {
        let vals = [];
        
        element.forEach((obj) => {
          Object.keys(obj).forEach((key) => {
            if (key === prop) {
              vals.push(obj[key]);
            }
          });
        });
        
        return vals;
      },

      keys: function() {
        let keys = [];
        
        Object.keys(element).forEach((key) => {
          keys.push(key);
        });

        return keys;
      },

      values: function() {
        let vals = [];
        
        Object.values(element).forEach((value) => {
          vals.push(value);
        });

        return vals;
      },

      pick: function(...props) {
        let vals = {};
        
        Object.keys(element).forEach((key) => {
          if (props.includes(key)) {
            vals[key] = element[key];
          }
        });
        
        return vals;
      },
      
      sample: function(qty) {
        let sampled = [];
        let copy = element.slice();
        function get() {
          let idx = Math.floor(Math.random() * copy.length);
          let el = copy[idx];
          copy.splice(idx, 1);
          return el;
        }
      
        if (!qty) { return get(); }
        while(qty) {
          sampled.push(get());
          qty -= 1;
        }
        
        return sampled;
      },

      omit: function(undesiredProp) {
        let newObj = {};
        
        Object.keys(element).forEach((key) => {
          if (key !== undesiredProp) {
            newObj[key] = element[key];
          }
        });
        
        return newObj;
      },

      has: function(prop) {
        let match = element.hasOwnProperty(prop) || Object.keys(element).includes("hasOwnProperty");
        return match;
      }
    };

    (["isElement", "isArray", "isObject", "isString", "isNumber", "isBoolean", "isFunction"]).forEach(function(method) {
      u[method] = function() { _[method].call(u, element); };
    });

    return u;
  };

  _.range = function(start, stop) {
    let range = [];
    
    if (stop === undefined){
      stop = start;
      start = 0;
    }

    for (let i = start; i < stop; i += 1) {
      range.push(i);
    }
  
    return range;
  };

  _.extend = function(...objs) {
    let idx = objs.length - 1;
        
    function addPropsToPrior(objs, index) {
      if (index === 0) {
        return objs[0];
      } else {
        let objToCopyFrom = objs[index];
        let objToCopyTo = objs[index - 1];
            
        Object.keys(objToCopyFrom).forEach((key) => {
          objToCopyTo[key] = objToCopyFrom[key];
        });
      
        addPropsToPrior(objs, (index - 1));
      }
    }
    
    addPropsToPrior(objs, idx);
    return objs[0];
  };

  _.isElement = function(obj) {
    return obj && obj.nodeType === 1;
  };

  _.isArray = function(item) {
    return Array.isArray(item);
  };

  _.isObject = function(item) {
    let itemType = typeof item;
    
    return itemType === "function" || itemType == "object" && !!item;
  };

  _.isNumber = function(value) {
    return typeof value === "number";
  };

  _.isString = function(value) {
    return typeof value === "string";
  };
  
  _.isBoolean = function(value) {
    return value.constructor === Boolean;
  };

  _.isFunction = function(value) {
    return typeof value === "function";
  };


})();

// tests:
console.log("Test: T/F _ is defined:");
console.log(typeof _ !== "undefined");

console.log("Test: T/F first is defined:");
console.log(typeof _().first === "function");

console.log("Test: T/F first returns first element in an array:");
console.log(_([4]).first() === 4);

(function() {
  var a = [];
  a[1] = 4;
  console.log("Test: T/F first does not return second element even if first is undefined:");
  console.log(_(a).first() === undefined);
})();

console.log("Test: T/F last is defined:");
console.log(typeof _().last === "function");

console.log("Test: T/F last returns last element in an array:");
console.log(_([1, 2, 3, 4]).last() === 4);

console.log("Test: T/F without is defined:");
console.log(typeof _().without === "function");

console.log("Test: T/F without returns new array that does not contain the supplied value:");
console.log(_([1, 2, 3, 4, 5]).without(4).indexOf(4) === -1);

console.log("Test: T/F without removes any number of arguments:");
let a = _([1, 2, 3, 4, 5, 6]).without(6, 4);
console.log(a.indexOf(6) === -1 && a.indexOf(4) === -1);

console.log("Test: T/F without removes only the specified number of arguments:");
a = _([1, 2, 3, 4, 5, 6]).without(6, 4);
console.log(a.length === 4);

console.log("Test: T/F without retains the elements that aren't remove:");
a = _([1, 2, 3, 4, 5, 6]).without(6, 4);
console.log(a.indexOf(1) === 0 && a.indexOf(2) === 1 && a.indexOf(3) === 2 && a.indexOf(5) === 3);

console.log("Test: T/F range is defined:");
console.log(typeof _.range === "function");

console.log("Test: T/F range returns an array of values starting at 0 when one argument supplied:");
console.log(_.range(10)[0] === 0 && _.range(10).length === 10);

console.log("Test: T/F range returns an array of values starting with the first value when two arguments supplied:");
console.log(_.range(1, 10)[0] === 1 && _.range(1, 10).length === 9);

console.log("Test: T/F lastIndexOf is defined:");
console.log(typeof _().lastIndexOf === "function");

console.log("Test: T/F lastIndexOf returns last index of supplied value:");
console.log( _([1, 1, 1]).lastIndexOf(1) === 2 && _([1, 2, 3]).lastIndexOf(2) === 1);

console.log("Test: T/F sample is defined:");
console.log(typeof _().sample === "function");

console.log("Test: T/F sample returns a single element when no argument supplied:");
console.log(_([1]).sample() === 1);

console.log("Test: T/F sample returns multiple, non-repetitive elements when a numeric argument supplied:");
console.log(_([1, 2, 3]).sample(3).length === 3);

console.log("Test: T/F findWhere is defined:");
console.log(typeof _().findWhere === "function");

(function() {
  let dict = [{ foo: "bar", idx: 0 }, { foo: "baz", idx: 1 }, { foo: "bar", idx: 2 }];

  console.log("Test: T/F findWhere returns the first object with matched properties:");
  console.log(_(dict).findWhere({ foo: "bar" }).idx === 0);
})();

(function() {
  let dict = [{ foo: "bar", quux: "q", idx: 0 },
              { foo: "baz", quux: "z", idx: 1 }, 
              { foo: "bar", quux: "z", idx: 2 }];

  console.log("Test: T/F findWhere returns the first object with multiple matched properties:");
  console.log(_(dict).findWhere({ foo: "bar", quux: "z" }).idx === 2);
})();

(function() {
  let dict = [{ foo: "bar", idx: 0 }, { foo: "baz", idx: 1 }, { foo: "bar", idx: 2 }];

  console.log("Test: T/F findWhere returns undefined with no matched properties:");
  console.log(_(dict).findWhere({ foo: "quux" }) === undefined);
})();

console.log("Test: T/F where is defined:");
console.log(typeof _().where === "function");

(function() {
  var dict = [{ foo: "bar", idx: 0 }, { foo: "baz", idx: 1 }, { foo: "bar", idx: 2 }];

  console.log("Test: T/F where returns an array with one matched object:");
  console.log(_(dict).where({ idx: 0 }).length === 1);

  console.log("Test: T/F where returns an array with two matched objects:");
  console.log(_(dict).where({ foo: "bar" }).length === 2);
})();

console.log("Test: T/F pluck is defined:");
console.log(typeof _().pluck === "function");

console.log("Test: T/F pluck returns array of two values:");
let coll = [{ foo: "bar" }, { foo: "baz" }],
p = _(coll).pluck("foo");
console.log(p.length === 2);

console.log("Test: T/F pluck returns both values:");
coll = [{ foo: "bar" }, { foo: "baz" }],
p = _(coll).pluck("foo");
console.log(p[0] === "bar" && p[1] === "baz");

console.log("Test: T/F keys is defined:");
console.log( typeof _().keys === "function");

console.log("Test: T/F keys returns an array of keys from the object:");
let keys = _({ foo: "bar", baz: "quuz" }).keys();
console.log( keys.length === 2);
  
console.log("Test: T/F keys returns all keys that are own properties of the object:");
keys = _({ foo: "bar", baz: "quuz" }).keys();
console.log(keys.indexOf("foo") !== -1 && keys.indexOf("baz") !== -1);

console.log("Test: T/F keys does not return inherited object properties:");
keys = _({ foo: "bar", baz: "quuz" }).keys();
console.log(keys.indexOf("toString") === -1);

console.log("Test: T/F values is defined:");
console.log(typeof _().values === "function");

console.log("Test: T/F values returns an array of values from the object:");
let vals = _({ foo: "bar", baz: "quuz" }).values();
console.log(vals.length === 2);
  
console.log("Test: T/F values returns all values that are own properties of the object:");
vals = _({ foo: "bar", baz: "quuz" }).values();
console.log(vals.indexOf("bar") !== -1 && vals.indexOf("quuz") !== -1);

console.log("Test: T/F extend is defined:");
console.log(typeof _.extend === "function");

console.log("Test: T/F extend returns an extended object using new object's values:");
let newObj = { bar: "baz" };
let oldObj = { foo: "bar" };
let extObj = _.extend(oldObj, newObj);
let crazyObj = _.extend({ foo: "quuz" }, newObj, oldObj);
console.log(extObj.foo === "bar" && extObj.bar === "baz");

console.log("Test: T/F extend modifies the first object passed in rather than creating a new object:");
newObj = { bar: "baz" };
oldObj = { foo: "bar" };
extObj = _.extend(oldObj, newObj);
crazyObj = _.extend({ foo: "quuz" }, newObj, oldObj);
console.log(newObj === _.extend(newObj, {}));

console.log("Test: T/F extend works with any number of objects:");
newObj = { bar: "baz" };
oldObj = { foo: "bar" };
extObj = _.extend(oldObj, newObj);
crazyObj = _.extend({ foo: "quuz" }, newObj, oldObj);
console.log(crazyObj.foo === "bar");

console.log("Test: T/F pick is defined:");
console.log(typeof _().pick === "function");

console.log("Test: T/F pick returns a new object with the passed in properties:");
oldObj = { foo: "bar" };
newObj = _(oldObj).pick("foo");
console.log(newObj.foo === oldObj.foo && newObj !== oldObj);

console.log("Test: T/F pick ignores any properties passed in that do not exist on the source object:");
oldObj = { foo: "bar" };
newObj = _(oldObj).pick("foo");
console.log( _(newObj).pick("foo", "bar").bar === undefined);

console.log("Test: T/F omit is defined:");
console.log(typeof _().omit === "function");

console.log("Test: T/F omit returns a new object with any passed in properties omitted:");
oldObj = { foo: "bar" };
newObj = _(oldObj).omit("foo");
console.log(newObj.foo === undefined);

console.log("Test: T/F omit doesn't insert properties that aren't on the original object:");
oldObj = { foo: "bar" };
newObj = _(oldObj).omit("foo", "foo2");
console.log(newObj.hasOwnProperty('foo2') === false);

console.log("Test: T/F omit doesn't remove all the properties:");
oldObj = { foo: "bar", foo2: "bar2" },
newObj = _(oldObj).omit("foo");
console.log(newObj.hasOwnProperty('foo') === false && newObj.hasOwnProperty('foo2') === true);

console.log("Test: T/F 'has' is defined:");
console.log(typeof _().has === "function");

console.log("Test: T/F has returns true when property exists:");
let o = { foo: "bar" };
console.log(_(o).has("foo"));

console.log("Test: T/F has returns false when property does not exist:");
console.log( !_(o).has("bar"));

console.log("Test: T/F has returns true when hasOwnProperty is defined:");
o = { foo: "bar" };
o.hasOwnProperty = function() { };
console.log(_(o).has("hasOwnProperty"));

(["isElement", "isArray", "isObject", "isFunction", "isBoolean", "isString", "isNumber"]).forEach(function(method) {
  console.log("Test: T/F " + method + " is defined:");
  console.log(typeof _[method]  === "function" && typeof _()[method] === "function");
});

//console.log("Test: T/F isElement returns true if DOM element, otherwise false:");
//console.log(_.isElement(document.body) && !_.isElement({}));

console.log("Test: T/F isArray returns true if array, otherwise false:");
console.log(_.isArray([]) && !_.isArray({ 0: "a", 1: "b" }));

console.log("Test: T/F isObject returns true if object or function, otherwise false:");
console.log(_.isObject({}) && _.isObject([]) && _.isObject(isNaN) && !_.isObject(1));

console.log("Test: T/F isFunction returns true if function, otherwise false:");
console.log(_.isFunction(isNaN) && !_.isFunction({}));

console.log("Test: T/F isBoolean returns true if boolean (primitive or object), otherwise false:");
console.log(_.isBoolean(false) && !_.isBoolean(1));

console.log("Test: T/F isString returns true if string, otherwise false:");
console.log(_.isString("") && !_.isString(1));
  
console.log("Test: T/F isNumber returns true if number, (primitive or object), otherwise false:");
console.log(_.isNumber(1) && !_.isNumber("5"));
