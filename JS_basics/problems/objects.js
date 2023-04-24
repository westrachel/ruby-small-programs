// 1. write a function that takes 2 Objects as arguments and copies all
// properties from the 1st object to the second. The function should
// return the # of properties copied
function copyProperties(object1, object2) {
  for (let property in object1) {
    object2[property] = object1[property];
  }

  return Object.keys(object1).length;
}

// 2. Write a function that takes 1 string argument and returns an object
// that contains the counts of each word that appears in the string
// assumption: words are delimited by single spaces
function objectHasProperty(object, propertyName) {
  return Object.keys(object).indexOf(propertyName) !== -1;
}

function incrementProperty(object, propertyName) {
  if (objectHasProperty(object, propertyName)) {
    object[propertyName] += 1;
  } else {
    object[propertyName] = 1;
  }

  return object[propertyName];
}

function wordCount(string) {
  let words = string.split(' ');
  let counts = {};

  for (let index = 0; index < words.length; index += 1) {
    let word = words[index];
    incrementProperty(counts, word);
  }

  return counts;
}

wordCount('box car cat bag box'); // { bag: 1, box: 2, car: 1, cat: 1 }

// 3. Array comparison
// write a function that returns a boolean specifying if the arrays contain
// the same values
// reqs:
// > based on test cases, only comparing elements at non-negative integer indices
function areArraysEqual(arr1, arr2) {
  if (arr1.length !== arr2.length) {
    return false;
  }

  let copyArr2 = arr2.slice();
  for (let idx = 0; idx < arr1.length; idx += 1) {
    let indexOfArr1Element = copyArr2.indexOf(arr1[idx]);
    if (indexOfArr1Element >= 0) {
      copyArr2.splice(indexOfArr1Element, 1);
    } else {
      return false;
    }
  }

  return true;
}

areArraysEqual([1, 2, 3], [1, 2, 3]);                  // true
areArraysEqual([1, 2, 3], [3, 2, 1]);                  // true
areArraysEqual(['a', 'b', 'c'], ['b', 'c', 'a']);      // true
areArraysEqual(['1', 2, 3], [1, 2, 3]);                // false
areArraysEqual([1, 1, 2, 3], [3, 1, 2, 1]);            // true
areArraysEqual([1, 2, 3, 4], [1, 1, 2, 3]);            // false
areArraysEqual([1, 1, 2, 2], [4, 2, 3, 1]);            // false
areArraysEqual([1, 1, 2], [1, 2, 2]);                  // false
areArraysEqual([1, 1, 1], [1, 1]);                     // false

// 4. Write a function that accepts an array of objects containing movie info 
//  and returns an Array of Objects that contain only the id & title key/value
//  pairs
//  > only add movie info if both the id and title properties exist
//  > the return should be an array of objects
// approach:
// > iterate over each subobject
// > map the suboject to an object containing only the id & title properties
//    <=> if the suboject doesn't have both properties than return an empty object
// > filter down the arrays of objects and select only the objects that are nonempty
function findIdTitle(obj) {
  let keys = Object.keys(obj);
  if (keys.includes("id") && keys.includes("title")) {
    return { id: obj.id, title: obj.title };
  }

  return {};
}

function processReleaseData(data) {
  let idsTitles = data.map(obj => findIdTitle(obj));
  return idsTitles.filter(obj => Object.keys(obj).length !== 0);
}

let newReleases = [
  {
    'id': 70111470,
    'title': 'Die Hard',
    'boxart': 'http://cdn-0.nflximg.com/images/2891/DieHard.jpg',
    'uri': 'http://api.netflix.com/catalog/titles/movies/70111470',
    'rating': [4.0],
    'bookmark': [],
  },
  {
    'id': 654356453,
    'boxart': 'http://cdn-0.nflximg.com/images/2891/BadBoys.jpg',
    'uri': 'http://api.netflix.com/catalog/titles/movies/70111470',
    'rating': [5.0],
    'bookmark': [{ id:432534, time:65876586 }],
  },
  {
    'title': 'The Chamber',
    'boxart': 'http://cdn-0.nflximg.com/images/2891/TheChamber.jpg',
    'uri': 'http://api.netflix.com/catalog/titles/movies/70111470',
    'rating': [4.0],
    'bookmark': [],
  },
  {
    'id': 675465,
    'title': 'Fracture',
    'boxart': 'http://cdn-0.nflximg.com/images/2891/Fracture.jpg',
    'uri': 'http://api.netflix.com/catalog/titles/movies/70111470',
    'rating': [5.0],
    'bookmark': [{ id:432534, time:65876586 }],
  },
];

processReleaseData(newReleases);
// return:
// [{ id: 70111470, title: 'Die Hard'}, { id: 675465, title: 'Fracture' }];

// 5. Prep Band Data
// > remove dots from names of bands
// > capitalize each word in a band name
// > replace the values associated with the country property w/ 'Canada'
let bands = [
  { name: 'sunset rubdown', country: 'UK', active: false },
  { name: 'women', country: 'Germany', active: false },
  { name: 'a silver mt. zion', country: 'Spain', active: true },
];

function removeDotsBandName(band) {
  band.name = band.name.replace(/\./g, '');
  return band;
}

function capitalizeBandName(band) {
  band.name = band.name.split(' ')
                .map(word => capitalizeName(word))
                .join(' ');
}

function capitalizeName(strName) {
  let start = strName[0].toUpperCase();
  let end = strName.slice(1, strName.length);
  return start + end;
}

function updateCountry(band) {
  band.country = 'Canada';
}

function processBands(data) {
  return data.map(band => { 
      removeDotsBandName(band);
      capitalizeBandName(band);
      updateCountry(band);
      return band;
    });
}

processBands(bands);
console.log(processBands(bands)[0]);
console.log(processBands(bands)[1]);
console.log(processBands(bands)[2]);
// should return:
//[
// { name: 'Sunset Rubdown', country: 'Canada', active: false },
// { name: 'Women', country: 'Canada', active: false },
// { name: 'A Silver Mt Zion', country: 'Canada', active: true },
// ]

// 6. filter a given list to a specified id
const transactions = [ { id: 101, movement: 'in',  quantity:  5 },
                       { id: 105, movement: 'in',  quantity: 10 },
                       { id: 102, movement: 'out', quantity: 17 },
                       { id: 101, movement: 'in',  quantity: 12 },
                       { id: 103, movement: 'out', quantity: 15 },
                       { id: 102, movement: 'out', quantity: 15 },
                       { id: 105, movement: 'in',  quantity: 25 },
                       { id: 101, movement: 'out', quantity: 18 },
                       { id: 102, movement: 'in',  quantity: 22 },
                       { id: 103, movement: 'out', quantity: 15 }, ];

function transactionsFor(idNum, list) {
  return list.filter(obj => obj.id === idNum);
}
transactionsFor(101, transactions);
// [ { id: 101, movement: "in",  quantity:  5 },
//   { id: 101, movement: "in",  quantity: 12 },
//   { id: 101, movement: "out", quantity: 18 }, ]

// 7. write a function that returns a boolean indicating if an
// item in a list is available or not
// > availability:
//    >> return true only if the sum of the quantity values of the item's
//         transactions is greater than zero. 
//    >> 'out' movements decrease the item's quantity
function isItemAvailable(idNum, list) {
  let total = 0;
  transactionsFor(idNum, list).forEach(item => {
    total += item.movement === 'in' ? item.quantity : -1 * item.quantity;
  });

  return total > 0;
}
isItemAvailable(101, transactions);     // false
isItemAvailable(105, transactions);     // true

