// 1. Join
// write a function that takes an array and a delimiter as arguments and joins
// the array elements into a string with the delimiter acting as the separator
// between elements
function join(arr, delimiter) {
  let joinedElements = '';

  for (let index = 0; index < arr.length - 1; index += 1) {
    joinedElements += arr[index];
    joinedElements += delimiter;
  }

  joinedElements += arr[arr.length - 1];
  return joinedElements;
}

join(['bri', 'tru', 'wha'], 'ck ');       // 'brick truck wha'
join([1, 2, 3], ' and ');                 // '1 and 2 and 3'

// 2. Array Comparison
// write a function that returns a boolean value specifying whether the arrays
// passed in contain the same values or not
function arraysEqual(arr1, arr2) {
  if (arr1.length !== arr2.length) {
    return false;
  } else {
    for (let index = 0; index < arr1.length; index += 1) {
      if (arr1[index] !== arr2[index]) {
        return false;
      }
    }
    return true;
  }
}

arraysEqual([1], [2]);                               // false
arraysEqual([1, 2], [1, 2, 3]);                      // false
arraysEqual([1, 'hi', true], [1, 'hi', false]);      // false
arraysEqual([1, 'hi', true], [1, 'hello', true]);    // false
arraysEqual([1, 'hi', true], [1, 'hi', true]);       // true

// 3. Odd Elements
// write a function that takes an array and returns a new array that contains
// elements located at odd indices of the passed in array
function oddElementsOf(arr) {
  let oddElements = [];

  for (let index = 1; index < arr.length; index += 2) {
    oddElements.push(arr[index]);
  }

  return oddElements;
}

oddElementsOf([1, 999, 202]);  

// 4. Sum Subarrays
// write a function that takes an array of subarrays argument and returns a new
//   array containing the totals of adding all the elements of each subarray
function subarraySums(arr) {
  let sums = [];

  for (let subarrIdx = 0; subarrIdx < arr.length; subarrIdx += 1) {
    let total = 0;
    let largestSubIdx = arr[subarrIdx].length - 1;

    for (let index = 0; index <= largestSubIdx; index += 1) {
      total += arr[subarrIdx][index];
    }

    sums.push(total);
  }

  return sums;
}

subarraySums([[2, 8, 5], [12, 48, 0], [12]]);  // [15, 60, 12]

// 5. De-duplicate
// write a function that takes an array and returns a new array with only unique
// values
function uniqueElements(arr) {
  let uniqueValues = [];

  for (let index = 0; index < arr.length; index += 1) {
    if (!uniqueValues.includes(arr[index])) {
      uniqueValues.push(arr[index]);
    }
  }

  return uniqueValues;
}

uniqueElements([1, 2, 4, 3, 4, 1, 5, 4]); // returns [1, 2, 4, 3, 5]

// 6. Missing From Sequence
// write a function that takes an array and returns a new array of all the
// integers the are missing from the sequence of the smallest to largest integer
// in the given array
function missing(arr) {
  let value = Math.min(...arr);
  let largest = Math.max(...arr);
  let missings = [];

  while (value < largest) {
    value += 1;
    if (!arr.includes(value)) {
      missings.push(value);
    }
  }

  return missings;
}

missing([-3, -2, 1, 5]);                  // [-1, 0, 2, 3, 4]
missing([1, 2, 3, 4]);                    // []
missing([1, 5]);                          // [2, 3, 4]
missing([6]);                             // []

// 7. Rebuilt Concat Method
// requirements:
// > first argument is always an array
// > second argument can be an array or another value
// > return value should be a new array that combines the first argument with
//   the second argument
// > if an object passed into the function is changed that change should be
//     reflected in the return value
// > the function should copy primitive values
function addArrElements(array, elements) {
  for (let idx = 0; idx < elements.length; idx += 1) {
    array.push(elements[idx]);
  }

  return array;
}

function concat(arr, value) {
  let newArr = [];
  newArr = addArrElements(newArr, arr);

  if (Array.isArray(value)) {
    newArr = addArrElements(newArr, value);
  } else {
    newArr.push(value);
  }
  
  return newArr;
}

concat([1, 2, 3], [4, 5, 6]);       // [1, 2, 3, 4, 5, 6]
concat([1, 2], 3);                  // [1, 2, 3]
concat([2, 3], ['two', 'three']);   // [2, 3, "two", "three"]
concat([2, 3], 'four');             // [2, 3, "four"]

const obj = { a: 2, b: 3 };
const newArray = concat([2, 3], obj);
newArray[2];           // { a: 2, b: 3 }
obj.a = 'two';
newArray[2];          // { a: "two", b: 3 }

// update method to allow for accepting more than 2 arguments
function concatMany(...values) {
  let newArr = [];

  for (let index = 0; index < values.length; index += 1) {
    if (Array.isArray(values[index])) {
      newArr = addArrElements(newArr, values[index]);
    } else {
      newArr.push(values[index]);
    }
  }
  
  return newArr;
}

concatMany([1, 2, 3], [4, 5, 6], [7, 8, 9]);    // [1, 2, 3, 4, 5, 6, 7, 8, 9]
concatMany([1, 2], 'a', ['one', 'two']);        // [1, 2, "a", "one", "two"]
concatMany([1, 2], ['three'], 4);               // [1, 2, "three", 4]

// 8. Running Totals
// write a function that accepts an array argument and returns a new array
// whose values represent the running total of the sum of elements in the
// passed in array
function runningTotal(array) {
  let totals = [];
  let total = 0;

  for (let idx = 0; idx < array.length; idx += 1) {
    total += array[idx];
    totals.push(total);
  }

  return totals;
}

runningTotal([2, 5, 13]);             // [2, 7, 20]
runningTotal([14, 11, 7, 15, 20]);    // [14, 25, 32, 47, 67]
runningTotal([3]);                    // [3]
runningTotal([]);                     // []

// 9. Union
// write a function that accepts 2 array arguments and returns
// a new array containing only the union of elements from both
// there shouldn't be any repeat values in the returned array
function addToArray(newArr, values) {
  for(let idx = 0; idx < values.length; idx += 1) {
    if (!newArr.includes(values[idx])) {
      newArr.push(values[idx]);
    }
  }

  return newArr;
}

function union(arr1, arr2) {
  let combo = addToArray([], arr1);
  combo = addToArray(combo, arr2);

  return combo;
}

union([1, 3, 5], [3, 6, 9]);    // [1, 3, 5, 6, 9]

// 10. Halvsies
// write a function that splits a given array argument into 2 separate
// arrays
function halvsies(array) {
  let midpoint = Math.ceil(array.length / 2);
  let firstArr = [];
  let secondArr = [];

  for (let idx = 0; idx < midpoint; idx += 1) {
    firstArr.push(array[idx]);
  }

  for (let idx = midpoint; idx < array.length; idx += 1) {
    secondArr.push(array[idx]);
  }

  return [firstArr, secondArr];
}

halvsies([1, 2, 3, 4]);       // [[1, 2], [3, 4]]
halvsies([1, 5, 2, 4, 3]);    // [[1, 5, 2], [4, 3]]
halvsies([5]);                // [[5], []]
halvsies([]);                 // [[], []]

// 11. Find the one duplicate in a given array
function findDup(array) {
  let counts = {};

  for (let idx = 0; idx < array.length; idx += 1) {
    let value = String(array[idx]);

    if (Object.keys(counts).includes(value)) {
      return array[idx];
    } else {
      counts[value] = 1;
    }
  }

}

findDup([1, 5, 3, 1]);  // 1
findDup([18, 9, 36, 96, 31, 19,
         54, 75, 42, 15, 38, 25,
         97, 92, 46, 69, 91, 59,
         53, 27, 14, 61, 90, 81,
         8, 63, 95, 99, 30, 65,
         78, 76, 48, 16, 93, 77,
         52, 49, 37, 29, 89, 10,
         84, 1, 47, 68, 12, 33,
         86, 60, 41, 44, 83, 35,
         94, 73, 98, 3, 64, 82,
         55, 79, 80, 21, 39, 72,
         13, 50,  6, 70, 85, 87,
         51, 17, 66, 20, 28, 26,
         2, 22, 40, 23, 71, 62,
         73, 32, 43, 24, 4, 56,
         7, 34, 57, 74, 45, 11,
         88, 67, 5, 58]);  // 73

// 12. Alternate lists
// can assume nonempty arguments + same lengthed arguments
function interleave(arr1, arr2) {
  let newArr = [];
  
  for (let idx = 0; idx < arr1.length; idx += 1) {
    newArr.push(arr1[idx]);
    newArr.push(arr2[idx]);
  }

  return newArr;
}
interleave([1, 2, 3], ['a', 'b', 'c']); // [1, "a", 2, "b", 3, "c"]

// 13. Calc the straight multiplicative avg rounded to 3 
//  decimals & returned as a string
function showMultiplicativeAverage(array) {
  let avg = 1;

  for (let idx = 0; idx < array.length; idx += 1) {
    avg *= array[idx];
  }

  avg /= array.length;

  return avg.toFixed(3);
}

showMultiplicativeAverage([3, 5]);                  // "7.500"
showMultiplicativeAverage([2, 5, 7, 11, 13, 17]);   // "28361.667"

// 14. Multiply lists
function multiplyLists(arr1, arr2) {
  let products = [];

  for (let idx = 0; idx < arr1.length; idx += 1) {
    let product = arr1[idx] * arr2[idx];
    products.push(product);
  }

  return products;
}
multiplyLists([3, 5, 7], [9, 10, 11]);  // [27, 50, 77]


// 15. Digit list
function digitList(num) {
  return String(num).split('').map(x => Number(x));
}

digitList(12345);       // [1, 2, 3, 4, 5]
digitList(7);           // [7]

// 16. Log the Occurrences of Array Elements
function countOccurrences(arr) {
  let counts = {};

  for (let idx = 0; idx < arr.length; idx += 1) {
    if (Object.keys(counts).includes(arr[idx])) {
      counts[arr[idx]] += 1;
    } else {
      counts[arr[idx]] = 1;
    }
  }

  for (let property in counts) {
    console.log(property + " => " + counts[property]);
  }
}
const vehicles = ['car', 'car', 'truck', 'car', 'SUV', 'truck',
                'motorcycle', 'motorcycle', 'car', 'truck'];
countOccurrences(vehicles);
// console output
// car => 4
// truck => 3
// SUV => 1
// motorcycle => 2

// 17. Sequence Count
function sequence(count, start) {
  let seq = [];

  for (let multiplier = 1; multiplier <= count; multiplier += 1) {
    seq.push(multiplier * start);
  }

  return seq;
}
sequence(5, 1);          // [1, 2, 3, 4, 5]
sequence(4, -7);         // [-7, -14, -21, -28]
sequence(3, 0);          // [0, 0, 0]
sequence(0, 1000000);    // []

// 18. forEach rebuilt:
// requirements:
// > arguments = array & a function
// > function passed to myForEach should reassign a variable in the outer scope
function myForEach(array, func) {
  for (let idx = 0; idx < array.length; idx += 1) {
    func(array[idx], idx, array);
  }
}


let min = Infinity;
let getMin = value => (min = value <= min ? value : min);
myForEach([4, 5, 12, 23, 3], getMin);
console.log(min);

// 19. filter rebuilt:
// requirements:
// > arguments = array & a function
// > returns an array w/ values that when passed to the provided function
//    argument return true
function myFilter(array, func) {
  let newArr = [];

  for (let idx = 0; idx < array.length; idx += 1) {
    if (func(array[idx])) {
      newArr.push(array[idx]);
    }
  }

  return newArr;
}

let isPythagoreanTriple = function (triple) {
  return Math.pow(triple.a, 2) + Math.pow(triple.b, 2) === Math.pow(triple.c, 2);
};

myFilter([{ a: 3, b: 4,  c: 5 },
          { a: 5, b: 12, c: 13 },
          { a: 1, b: 2,  c: 3 },], isPythagoreanTriple);
// returns:
// [ { a: 3, b: 4, c: 5 },
//   { a: 5, b: 12, c: 13 } ]

// 20. map rebuilt:
// requirements:
// > arguments = array & a function (the callback)
// > return a new array whose values are the return values of the
//    callback Function.
function myMap(array, func) {
  let newArr = [];
  array.forEach((element) => newArr.push(func(element)));

  return newArr;
}

let plusOne = n => n + 1;
myMap([1, 2, 3, 4], plusOne);       // [ 2, 3, 4, 5 ]

// 21. reduce rebuilt:
// > arguments: array & a function
// > allow for a 3rd optional argument that acts as an initial value
//     <=> if the caller omits the initial value, myReduce should use
//          the first element of the Array as the initial value
// > return: value returned by the last invocation of the callback function
function myReduce(array, func, initial) {
  let value = array[0];
  let index = 1;

  if (initial !== undefined) {
    value = initial;
    index = 0;
  }

  array.slice(index).forEach(element => value = func(value, element));
  return value;
}


let smallest = (result, value) => (result <= value ? result : value);
let sum = (result, value) => result + value;

myReduce([5, 12, 15, 1, 6], smallest);     // 1
myReduce([5, 12, 15, 1, 6], sum, 10);      // 49

// 22. Total Area:
// write a function that accepts an Array of subarrays that contain
// 2 integer elements that represent the height and width of a rectangle
// the return value should be the total area of all all rectangles
// approach:
// i. iterate over each subarray and calculate its area by multiplying
//     the 2 elements
// ii. sum all the areas calculated
// iii. return the sum calculated
function sumArea(priorArea, area) {
  return priorArea + area;
}

function totalArea(array) {
  return array.map(subarr => subarr[0] * subarr[1]).reduce(sumArea);
}
let rectangles = [[3, 4], [6, 6], [1, 8], [9, 9], [2, 2]];

totalArea(rectangles);    // 141

// 23. Total Square Area:
// write a function that calcs the total area of a set of squares
// <=> so need to filter to only squares first
function totalSquareArea(array) {
  let squares = array.filter(subarray => subarray[0] === subarray[1]);
  return totalArea(squares);
}

let squares = [[3, 4], [6, 6], [1, 8], [9, 9], [2, 2]];

totalSquareArea(squares);    // 121

// 24. Anagrams
// write a function that accepts a word and array as arguments and
// returns an aray contains only selected words from the array
// that are anagrams of the word argument
// approach:
// i. sort the letters of the given word argument alphabetically
// ii. iterate through the array containing strings
// iii. select the word only if its characters sorted value produce
//   a string that's equivalent to the string found under step i.
function sortAlphabetically(word) {
  return word.split('').sort().join('');
}
function anagram(word, list) {
  let sorted = sortAlphabetically(word);
  return list.filter(string => 
    sortAlphabetically(string) === sorted);
}

anagram('listen', ['enlists', 'google', 'inlets', 'banana']);  // [ "inlets" ]
anagram('listen', ['enlist', 'google', 'inlets', 'banana']);   // [ "enlist", "inlets" ]

// 25. write a function that takes 1 string argument and returns a list of
// substrings of the given string
// > each substring should begin w/ the 1st letter of the word
// > the return value should be an array object that contains the substrings
//      ordered from shortest to longest
function leadingSubstrings(str) {
  let maxNum = str.length + 1;
  let lengthsOfSubstrs = [...Array(maxNum).keys()].slice(1);

  return lengthsOfSubstrs.map(length => 
    str.slice(0, length));
}

leadingSubstrings('abc');      // ["a", "ab", "abc"]
leadingSubstrings('a');        // ["a"]
leadingSubstrings('xyzzy');    // ["x", "xy", "xyz", "xyzz", "xyzzy"]

// 26. find all substrings of a given string and return them in an array
// requirements:
// > order the returned array by where in the string the substring begins
// > all substrings that start at index position 0 should come first
// > return the substrings at a given index from shortest to longest
function substrings(string){
  let substrings = [];

  for (let idx = 0; idx < string.length; idx += 1) {
    let subStr = string.slice(idx, string.length);
    
    leadingSubstrings(subStr).forEach(str => 
      substrings.push(str));
  }
  return substrings; 
}

substrings('abcde');
// [ "a", "ab", "abc", "abcd", "abcde",
//   "b", "bc", "bcd", "bcde",
//   "c", "cd", "cde",
//   "d", "de",
//   "e" ]

// 27. Palindromic Substrings
// write a function that returns an array of all substrings of a
//  given string that are palindromic
// requirements:
// > each substring must consist of the same sequence of characters
//    forwards as backwards
// > The substrings in the returned list should be sorted by their order
//    of appearance in the input string
// > Duplicate substrings should be included multiple times
// > palindromes are case sensitive
//    >> 'AbcbA' is a palindrome
//    >> 'Abcba' and 'Abc-bA' are not palindroms
// > single characters are not palindromes

// approach:
// i. find all substrings of the given string
// ii. iterate through the substrings found and filter to only substrings
//  that are palindromes
//    > to check if a substring is a palindrome:
//       > split the string into characters
//       > reverse the characters
//       > join the characters back together
//       > check if the reversed substring is equivalent to the substring itself
//       > also check that the substring has a length greater than 1
function palindromes(string) {
  return substrings(string).filter(isPalindrome);
}

function isPalindrome(str) {
  return str === str.split('').reverse().join('') && str.length > 1;
}

palindromes('abcd');       // []
palindromes('madam');      // [ "madam", "ada" ]

palindromes('hello-madam-did-madam-goodbye');
// [ "ll", "-madam-", "-madam-did-madam-", "madam", "madam-did-madam", "ada",
//   "adam-did-mada", "dam-did-mad", "am-did-ma", "m-did-m", "-did-", "did",
//   "-madam-", "madam", "ada", "oo" ]

palindromes('knitting cassettes');
//[ "nittin", "itti", "tt", "ss", "settes", "ette", "tt" ]

// 28. stagger the case of all alphabetical letters of a given string
// > the first letter should be capitalized
// > Non-alphabetic characters should not be changed, but do count as characters
//      for determining when to switch between upper and lower case
function staggeredCase(str) {
  let staggeredCaseStr = '';
  let capitalizeFlag = true;

  for (let idx = 0; idx < str.length; idx += 1) {
    let char = capitalizeFlag ? str[idx].toUpperCase() : str[idx].toLowerCase();
    staggeredCaseStr += char;
    capitalizeFlag = capitalizeFlag ? false : true;
  }

  return staggeredCaseStr;
}

staggeredCase('ALL_CAPS');                     // "AlL_CaPs"
staggeredCase('ignore 77 the 4444 numbers');   // "IgNoRe 77 ThE 4444 nUmBeRs"

// 29. stagger the case of all alphabetical letters of a given string
// > ignore non-alphabetic characters when determining whether a letter
//     should be upper or lower cased
function staggeredCaseLetters(str) {
  let staggeredCaseStr = '';
  let capitalizeFlag = true;

  for (let idx = 0; idx < str.length; idx += 1) {
    let char = str[idx];

    if (char.match(/[a-z]/i)) {
      char = capitalizeFlag ? char.toUpperCase() : char.toLowerCase();
      capitalizeFlag = capitalizeFlag ? false : true;
    }
    staggeredCaseStr += char;
  }

  return staggeredCaseStr;
}

staggeredCaseLetters('ALL CAPS');                     // "AlL cApS"
staggeredCaseLetters('ignore 77 the 444 numbers');    // "IgNoRe 77 ThE 444 nUmBeRs"

// 30. write a function that takes a string as an argument and returns an array
// that contains every word from the string, with each word followed by a space
//  and the word's length
// > if the argument is an empty string or if no argument is passed, the return
//   should be an empty array
// > every pair of words in the string will be separated by a single space
function wordLengths(string) {
  if (!string) {
    return [];
  }

  return string.split(' ').map(word => 
    word + " " + String(word.length));
}

wordLengths('cow sheep chicken');
// ["cow 3", "sheep 5", "chicken 7"]

wordLengths('baseball hot dogs and apple pie');
// ["baseball 8", "hot 3", "dogs 4", "and 3", "apple 5", "pie 3"]

wordLengths("It ain't easy, is it?");
// ["It 2", "ain't 5", "easy, 5", "is 2", "it? 3"]

wordLengths('Supercalifragilisticexpialidocious');
// ["Supercalifragilisticexpialidocious 34"]

wordLengths('');      // []
wordLengths();        // []

// 31. write a function that returns the # of times a word appears
// in a string of text
// > the word is case insensitive
const text = 'Sed ut perspiciatis unde omnis sed iste natus error sit voluptatem sed';

function searchWord(word, string) {
  let pattern = new RegExp(word, "gi");
  let numMatches = string.match(pattern).length;

  return numMatches ? numMatches : 0;
}
searchWord('hi', text);        // 0
searchWord('sed', text);      // 3

// update prior function to return the # of times a full word appears
// in a string of text
const moreText = 'Sedated ut perspiciatis sed iste natus error sit voluptatem sed';
function searchFullWord(word, string) {
  let matches = string.split(' ').filter(subWord =>
    subWord.toUpperCase() === word.toUpperCase());

  return matches.length;
}

searchFullWord('sed', moreText);   // 2
searchFullWord('hi', text);        // 0
searchFullWord('sed', text);      // 3

// 32. write a function that takes a word and a string of text as arguments &
// returns the string modified to highlight the word highlighted
// > highlighting consists of:
//     >> putting 2 asterisks ('**') on each side of the word
//     >> capitalizing every letter of the word to uppercase
// > can assume words are separated by single spaces
function highlightWord(word, string) {
  return string.split(' ').map(subWord => {
    if (subWord.toUpperCase() === word.toUpperCase()) {
      return '**' + subWord.toUpperCase() + '**';
    } else {
      return subWord;
    }
  }).join(' ');
}

highlightWord('sed', text);
// '**SED** ut perspiciatis unde omnis **SED** iste natus error sit voluptatem **SED**';

// 33. write a function that creates a grocery list by taking
// a 2 argument array and returning the string word of each subarray
// repeated the number of times specified by the numerical value in the subarray
// > assume no missing arguments and that the subarrays only contain 2 elements
//     the first being a string to repeat and the second being a number
function buyFruit(array) {
  return array.map(subArr => 
    repeatStrings(subArr[0], subArr[1])).join(' ').split(' ');
}

function repeatStrings(str, times) {
  let repeated = (str + ' ').repeat(times);
  return repeated.slice(0, repeated.length - 1);
}
buyFruit([['apple', 3], ['orange', 1], ['banana', 2]]);
// ["apple", "apple", "apple", "orange", "banana", "banana"]

// 34. rotate the first element of an array to the end of the array
function rotateArray(arr) {
  if (!Array.isArray(arr)) {
    return undefined;
  } else if(arr.length === 0) {
    return [];
  }
  return arr.slice(1).concat(arr[0]);
}

rotateArray([7, 3, 5, 2, 9, 1]);       // [3, 5, 2, 9, 1, 7]
rotateArray(['a', 'b', 'c']);          // ["b", "c", "a"]
rotateArray(['a']);                    // ["a"]
rotateArray([1, 'a', 3, 'c']);         // ["a", 3, "c", 1]
rotateArray([{ a: 2 }, [1, 2], 3]);    // [[1, 2], 3, { a: 2 }]
rotateArray([]);                       // []

// return `undefined` if the argument is not an array
rotateArray();                         // undefined
rotateArray(1);                        // undefined

// the input array is not mutated
const array = [1, 2, 3, 4];
rotateArray(array);       // [2, 3, 4, 1]       
array;                    // [1, 2, 3, 4]       