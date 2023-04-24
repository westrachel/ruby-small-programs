// Problem: Phone Number Parsing
// requirements:
// > if a given phone number is < 10 digits, it's invalid
// > if a given phone number is 10 digits, it's valid
// > if a given phone number is 11 digits:
//      > & the first digit is 1, then use the lst 10 digits
//      > & the first digit is not 1, then it's invalid
// > if a given phone number is > 11 digits, then it's invalid

// Data:
// input:
// > string number that consist of digits and special characters
//    > special characters include spaces, dashes, dots, and parentheses
// output:
// > if the given input is deemed invalid then return a string of 10 0s
// > return the 10 digit string phone number

// assumptions:
// > function will only be passed string inptus that contain one 'phone number'

// Algorithm:
// i. Check if the passed in string matches the regex pattern for exactly
//    10 character digits where the digits are string numbers 0 - 9
//        > if evaluates as true, then return the string number itself
// ii. check if the length of the string is < 10 digits or greater than 11 digits
//         > check the length property
//         > if either condition evaluates as true, then return a string with 10 zeros
// iii. check if the first element is equivalent to '1' (if prior branch wasn't evaluated
//         then the given string is exactly 11 digits)
//       > also check that the digits at the 1st index position through the 10th index
//           position are all string numbers 
//       > if both conditions evaluate as true, then return all the characters of the
//          given string except for the element at the zeroth index 
// iv. if none of the prior conditions evalaute as true, then return a string that contains
//   10 zeros
function tenDigits(string) {
  return string.match(/\b\d{10}\b/);
}


function prepCellNumber(str) {
  const INVALID_NUM = '0'.repeat(10);

  if (tenDigits(str)) {
    return str;
  } else if (str[0] === '1' &&
             str.length === 11 &&
             tenDigits(str.substring(1, 11))) {
    return str.substring(1, 11);
  } else {
    return INVALID_NUM;
  }
}


// Test Cases:
prepCellNumber('34523');         // '0000000000'
prepCellNumber('');              // '0000000000'
prepCellNumber('234ab');         // '0000000000'
prepCellNumber('34*232_012');    // '0000000000'
prepCellNumber('3452320012');    // '3452320012'
prepCellNumber('345232001233');  // '0000000000'
prepCellNumber('14523200123');   // '4523200123'
prepCellNumber('24523200123');   // '0000000000'

// Problem:
// requirements:
// > to spell a word, you can only use 1 letter from each letter block
// > you can only use each block 1x, so there should only be 1 instance
//     of each letter selected from a respective block
// > letters are case-insensitive 

// Data:
// input:
//  > assuming input will only be a string
// output:
//   > boolean that indicates if the word string argument can be spelled
//      w/ the given letter blocks

// Algorithm:
// i. create an object that stores each letter block as a key and an initial
//    count of the number of occurences of those letters as a value, so the initial
//    values should all be 0
//      <=> store the 2 letters concatenated as each key and exclude the colon
// ii. iterate through the characters of the string argument and check if they
//     are non-alphabetical and if they aren't then return false
//      > use for loop here to allow for ending early
// iii. uppercase the character being iterated over and find the corresponding
//      key that contains that uppercase character
//       > obtain an array of the keys of the object
//       > filter through the keys that are all unique letter pairs and select
//          the key that contains the uppercased character being iterated over
//     Object.keys(myObj).filter(letterPair => letterPair.includes(letter))
// iv.  add 1 to the value associated with that key
// v. check if the value exceeds 1 after the addition and if it does, return false
// vi. if haven't returned false, then return true

function isBlockWord(string) {
  let letterPairCounts = {
    'BO': 0, 'XK': 0, 'DQ': 0, 'CP': 0, 'NA': 0, 'GT': 0,
    'RE': 0, 'FS': 0, 'JW': 0, 'HU': 0, 'VI': 0, 'LY': 0,
    'ZM': 0,
  };
  let chars = string.split('');

  if (chars.length === 0) {
    return false;
  }

  for (let idx = 0; idx < chars.length; idx += 1) {
    let char = chars[idx].toUpperCase();

    if (!char.match(/[A-Z]/)) {
      return false;
    } else {
      let key = Object.keys(letterPairCounts).filter(
        letterPair => letterPair.includes(char));
      
      letterPairCounts[key] += 1;
      
      if (letterPairCounts[key] > 1) {
        return false;
      }
    }
  }

  return true;
}

// Test Cases:
isBlockWord('BATCH');        // true
isBlockWord('BBATCH');       // false
isBlockWord('BUTCH');        // false
isBlockWord('jest');         // true
isBlockWord('');             // false
isBlockWord('--*batch');     // false
isBlockWord('  ');           // false


// Problem:
// write a function that sorts an array based on an english word lookup

// requirements:
// > don't mutate the argument
// > sorting logic:
//     > sort alphabetically from a - z & by length so 'eight' should come
//        before 'eighteen'

// assumptions:
// > will only be given an array of numbers 0 through 19

// test case notes:
// > 8 is returned first in the first test case, and 'e' is the starting
//    letter that appears before any other starting letter of the english
//    word conversions of the given numbers in the array

// Data:
// > input: array of numbers, specifically integers 0 - 19
// > output: a new array of integers that corresponds w/ the inputted
//    array sorted based on the english word

// Algorithm:
// i. create an object constant where each key is a string integer 0 - 19
//    and each associated value is the english word of that string integer
// ii. iterate over the integers in the array argument and map each one to
//      the corresponding english word by first converting the number in the
//       array to a string 
// iii. sort the mapped array based on comparing the strings
//    string comparison w/ the < & > operators naturally follows the sorting
//     logic required implicitly by the test case
// iv. iterate over the sorted array of words and map each english word to 
//   the corresponding number integer using object key/value lookups
//    > find the key associated with the given value and convert that key
//      to a number

function alphabeticNumberSort(array) {
  const STR_TO_WORD = { '0': 'zero', '1': 'one', '2': 'two', '3': 'three',
    '4': 'four', '5': 'five', '6': 'six', '7': 'seven', '8': 'eight', 
    '9': 'nine', '10': 'ten', '11': 'eleven', '12': 'twelve', '13': 'thirteen',
    '14': 'fourteen', '15': 'fifteen', '16': 'sixteen', '17': 'seventeen',
    '18': 'eighteen', '19': 'nineteen',
  };

  let words = array.map(num => STR_TO_WORD[String(num)]);
  
  return words.sort(compareWords).map(word => 
    findKey(STR_TO_WORD, word));
}

function findKey(obj, value) {
  let keys = Object.keys(obj);

  for (keys in obj) {
    if (obj[keys] === value) {
      return Number(keys);
    }
  }

}

function compareWords(word1, word2) {
  if (word1 < word2) {
    return -1;
  } else if (word1 > word2) {
    return 1;
  }

  return 0;
}

// Test Cases:
alphabeticNumberSort(
   [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]);
// [8, 18, 11, 15, 5, 4, 14, 9, 19, 1, 7, 17, 6, 16, 10, 13, 3, 12, 2, 0]

//zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven, 
//twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen

alphabeticNumberSort([1, 2, 3]);
// [1, 3, 2]
// one, three, two


// Problem:
// find all multiplicative pairs
// reqs:
// > the array returned should be sorted from smallest number
//    to largest
// > neither argument will be an empty array
// > the arrays will only contain numbers

// Data:
// input: 2 array arguments that contain numbers
// output: new array that contains the product of all possible number combinations
//    of the provided array arguments
//   <=> the should be sorted in ascending numerical order

// Algorithm:
// i. iterate over one of the arrays
// ii. with each iteration:
//      > iterate over all the elements of the other array argument
//      > multiply each numerical element being iterated over
//      > push the product to a new array
// iii. sort the new array created from largest to smallest
// iv. return the sorted array
function multiplyAllPairs(arr1, arr2) {
  let products = [];

  arr1.forEach(num1 => {
    arr2.forEach(num2 => {
      products.push(num1 * num2);
    });
  });

  return products.sort((num1, num2) => num1 - num2);
}

// Test Cases:
multiplyAllPairs([2, 4], [4, 3, 1, 2]);    // [2, 4, 4, 6, 8, 8, 12, 16]
multiplyAllPairs([2, 2], [1, 1]);          // [2, 2, 2, 2]


// Problem:
// find the sum of sums of all subsequences 
// requirements:
// > subsequence:
// ex. [3, 5, 2] has the following subsequences:
//   (3) + (3 + 5) + (3 + 5 + 2)

// Data:
// input: argument will be a single array of numbers only <=> at least 1 number
// output: a number that represents the sum of sequences 

// Algorithm:
// i. declare a length variable that initially points to 1
// ii. declare a final length variable that points to the number associated with
//    the length property of the array argument
// iii. establish a for loop that will continue iterating until the number that the
//    length variable points to is equivalent to the final length variable
// iv. on each iteration:
//       > add 1 to the number that the length variable points to
//       > slice the array argument from the 0th index and pass in the
//           length variable's current value as the 2nd argument
// v. sum the number elements of the sliced array and add it to a running total value
//     that represents the sum of sums of each sequence
// vi. return the running total sum

function sumOfSums(array) {
  let finalLength = array.length;
  let sum = 0;

  for (let length = 1; length <= finalLength; length += 1) {
    sum += array.slice(0, length).reduce(
      (total, value) => total + value);
  }

  return sum;
}
sumOfSums([3, 5, 2]);        // (3) + (3 + 5) + (3 + 5 + 2) --> 21
sumOfSums([1, 5, 7, 3]);     // (1) + (1 + 5) + (1 + 5 + 7) + (1 + 5 + 7 + 3) --> 36
sumOfSums([4]);              // 4
sumOfSums([1, 2, 3, 4, 5]);  // 35

// 1000 lights
// > there's a bank of switches numbered from 1 to n
// > Every switch ties to 1 light that is initially off
// > on the first pass through the switches all of them
//    are toggled
// > on the second pass, only the even numbered (not indexed)
//      position switches are toggled (so 2nd switch, 4th switch,
//      6th switch)
// > on the third pass, switches 3, 6, 9, etc are toggled
// > the toggling process is repeated for n repetitions, where
//      n is the argumnet passed into a function

// Data: 
// input: number that represents the number of switches and
//    the number of repetitions of toggling switches
// assumptions: integer input that is > 0
// output: array of lights that are on after n repetitions

// data structure to store light status + light #
// let lights = {
//  '1': 'off';
//  '2': 'off';
//  ...
// }

// iteraton pattern:
// > toggle every light, so the incrementer would be 1 and
//    start toggling the first light
// > incrementer becomes 2 on 2nd iteration and toggle 2, 4, 6
// > incrementer becomes 3 on 3rd iteration and toggle 3, 6, 9

// Algorithm:
// i. declare and initialize an incrementer that starts a 1
// ii. declare and initialize an object whose keys are string
//     numbers starting from 1 and going up to and including 
//     the integer n argument <=> these are the light numbers
//      > assign each key's value as 'off'
// iii. iterate from 1 to n and on each iteration:
//      > iterate through all the keys in the lights object
//      > toggle the light numbers' values to their opposite value
//          so 'on' becomes 'off' and 'off' becomes 'on'
//          <=> only toggle the light numbers keys' values where
//            the key's string number converted to a number type is
//            a multiple of the incrementer
//      > add 1 to the incrementer after
// iv. filter the object's keys to only the keys that have associated
//       values equal to 'on'
// v. map the selected keys to numbers and return the array of numbers
function lightsOn(numLights) {
  let switchNums = [...Array((numLights + 1)).keys()].slice(1);
  let switches = createLightsObj(switchNums);
  
  switchNums.forEach(
    num => switches[String(num)] = 'off');
  
  switchNums.forEach(switchNum => {
    for (let strNum in switches) {
      if (Number(strNum) % switchNum === 0) {
        switches[strNum] = switches[strNum] === 'on' ? 'off' : 'on';
      }
    }
  });

  return filterObjKeysByValue(switches, 'on');
}

function createLightsObj(keys) {
  let obj = {};
  
  keys.forEach(num => obj[String(num)] = 'off');
  return obj;
}

function filterObjKeysByValue(obj, desiredValue) {
  let selectedKeys = [];

  for (let property in obj) {
    if (obj[property] === desiredValue) {
      selectedKeys.push(Number(property));
    }
  }

  return selectedKeys;
}

// test cases:
lightsOn(5);        // [1, 4]
// Detailed result of each round for `5` lights
// Round 1: all lights are on
// Round 2: lights 2 and 4 are now off;     1, 3, and 5 are on
// Round 3: lights 2, 3, and 4 are now off; 1 and 5 are on
// Round 4: lights 2 and 3 are now off;     1, 4, and 5 are on
// Round 5: lights 2, 3, and 5 are now off; 1 and 4 are on

lightsOn(100);      // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

// Problem:
// write a function that logs a four-pointed diamond in an n x n grid

// Data:
// input: an odd integer n 
//    > can assume only odd integers

// pattern based on test cases:
//  first row always has 1 star
//  next row has prior row's # of stars + 2
// ...
//  middle row has the integer argument # of stars
// ...
// increment backwards until log 1 star

// Algorithm:
// i. declare a rows variable that points to an empty array
// ii. iterate from 1 to the integer argument and on each iteration:
//     > push a string to the rows variable where the string is created
//       by concatenating a number of spaces with *s where there are
//         numStars number of stars and then a number of spaces to
//         the right of the stars
//     numLeftSpaces = (integer argument - numStars ) / 2
//     numRightSpaces = numLeftSpaces
//     row = ' '.repeat(numLeftSpaces) + '*'.repeat(umStars) + ' '.repeat(numRightSpaces)
// iii. iterate through the rows array and log each string element (a row
//     of the n x n grid) to the console
// iv. reverse the rows array and remove the first element (middle row w/ only stars)
// v. iterate through the reversed array's remaining elements and log to the console
//    each of the elements
function diamond(n) {
  let rows = [];
  let numStars = [...Array(n+1).keys()].slice(1).filter(
    num => num % 2 !== 0);

  numStars.forEach(num =>
    rows.push(createDiamondRow(num, n)));

  rows.forEach(printRow);
  rows.reverse().slice(1).forEach(printRow);
}

function createDiamondRow(numStars, length) {
  let numSpaces = (length - numStars ) / 2;
  let spaces = ' '.repeat(numSpaces);
  return spaces + '*'.repeat(numStars) + spaces; 
}

function printRow(row) {
  console.log(row);
}

// test cases:
diamond(1);
// logs
// *

diamond(3);
// logs
//  *
// ***
//  *

diamond(9);
// logs
//    *
//   ***
//  *****
// *******
//*********
// *******
//  *****
//   ***
//    *


// Problem:
// write a function that implements the Caesar Cipher
// > Caesar Cipher: substitutes a letter by another letter located a given number of positions away in the alphabet
// Ex: letter 'A' is right-shifted by 3 spots, it's substituted with the letter 'D'
//    <=> the specific shift value is the 'key'

// requirements:
// > only encrypt letters (including both lower + upper case)
// > Any other character is left as is
// > The substituted letters are in the same letter case as the original letter
// > If the key value for shifting exceeds the length of the alphabet, it wraps around from the beginning

// Data:
// > input: string first argument, that is the string to be encrypted & a numerical key value that
//    represents the number of positions to shift the given letters by
// <=> assuming 2nd argument can be negative or positive, but will be a number
// > output: encrypted string

// Algorithm:
// i. declare an array that contains all alphabetical letters a - z <=> put this in a helper method that
//     defines either an array of all uppercased or all lower cased letters based on an argument passed to
//     the method
//   > a is located at the 0th index, b is located at the first index, ..., z is located at the 25th index
//   > array's case should be uniform
// ii. 
// iii. iterate through the given string and translate the characters as necessary
//      > to check if the character being iterated over does need to be translated, check if it's an
//          alphabetical letter or not
//      > if it's not an alphabetical letter, return the character as is to the new string that will
//          hold the translated letters
// iv. if the character is an alphabetical lettr, then find it's index position in the array previusly
//      declared
//       > select the array that has the appropriate case for the letter
// v. add the 2nd argument's numerical value to the letter's index position
// vi. check if the result of the addition is greater than 25 or less than 0
//      > if the result of the addition is greater than 25, then find the difference between
//         the summation and 25 and subtract 1 to find the index position of the shifted
//         new character
//         ex: letter is "X" which has index position of 23 and 2nd argument is 3
//            summation = 3 + 23 = 26
//            new index = 26 - 25 - 1 = 0
//              x, y, z, a, b 
//      > if the result of the addition is less than 0, then add that negative difference
//          to 25 and add 1 and that will be the index of the shifted character
//         ex: letter 'C' will have index position 2 and the 2nd numerical argument is -5
//              difference = 2 + (-5) = -3 
//              new index = 25 + (-3) + 1 = 23
//               x, y, z, a, b, c
// vii. use the index position of the new character found in the prior step to subset the desired
//    character from the appropriately cased array
// viii. push the subsetted character to the new string holding translated letters
// ix. return the new string created with all shifted characters
function caesarEncrypt(str, num) {
  num = decrementNumericalShifter(num);

  return str.split('').map(char => {
    if (!char.match(/[A-Z]/i)) {
      return char;
    } else if (char.match(/[A-Z]/)) {
      return rotateLetter('uppercase', num, char);
    } else {
      return rotateLetter('lowercase', num, char);
    }
  }).join('');
}

function decrementNumericalShifter(num) {
  if (num > 26) {
    while (num > 26) {
      num -= 26;
    }
  } else if (num < -26) {
    while (num < -26) {
      num += 26;
    }
  }

  return num;
}

function rotateLetter(letterCase, n, letter) {
  const ABCS = casedAlphabet(letterCase);
  let currIdx = ABCS.indexOf(letter);
  let newIdx = currIdx + n;

  if (newIdx > 25) {
    newIdx = newIdx - 25 - 1;
  } else if (newIdx < 0) {
    newIdx = newIdx + 25 + 1;
  }

  return ABCS[newIdx];
}

function casedAlphabet(upperCaseFlag) {
  const ABCS = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S',
    'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

  if (upperCaseFlag === 'uppercase') {
    return ABCS;
  } else {
    return ABCS.map(letter => letter.toLowerCase());
  }
}


// Test Cases:
// simple shift
caesarEncrypt('A', 0);       // "A"
caesarEncrypt('A', 3);       // "D"
caesarEncrypt('C', -5);     // "X"
caesarEncrypt('X', 3);      // "A"
caesarEncrypt('C', -31);     // "X"

// wrap around
caesarEncrypt('y', 5);       // "d"    <=> "y", "z", "a", "b", "c", "d"
caesarEncrypt('a', 47);      // "v"
caesarEncrypt('a', 73);      // "v"

// all letters
caesarEncrypt('ABCDEFGHIJKLMNOPQRSTUVWXYZ', 25);
// "ZABCDEFGHIJKLMNOPQRSTUVWXY"

caesarEncrypt('The quick brown fox jumps over the lazy dog!', 5);
// "Ymj vznhp gwtbs ktc ozrux tajw ymj qfed itl!"


// many non-letters
caesarEncrypt('There are, as you can see, many punctuations. Right?; Wrong?', 2);
// "Vjgtg ctg, cu aqw ecp ugg, ocpa rwpevwcvkqpu. Tkijv?; Ytqpi?"


// Vigenere Cipher
// requirements:
// > shift value used for a letter is equal to its index value in the alphabet
//     'b' has an index of 1 <=> A-Z have indices 0 - 25 and a-z also have indices
//        0 - 25
// > only encrypt alphabetical letters 

// Data:
// input: string and a keyword
// output: translated string

// Algorithm:
// i. declare a keyword index that starts at 0 and will increment
//  up to the largest index of the given keyword string argument
// ii. declare a translated word empty string
// iii. loop through all the letters in the given string argument
// iv. on each iteration:
//   > check if the character is not alphabetical and if
//      it's not, then push the character as is to the translated string
//   > subset the given keyword to the letter that is at the numerical index
//        position where the numerical value is the keyword index's numerical value
//   > find the alphabetical index position of the subsetted letter of the
//      keyword <=> this is the current shift value for the alphabetical letter
//       being iterated over
//   > find the alphabetical index position of the current letter being iterated
//       over that needs to be shifted
//   > find the shifted letter by adding the current letter's index position
//   to the index position of the keyword's character in scope and then subtract 1
//   <=> then check if this value is greater than 25, and if it is subtract 25
//      to get the index of the shifted letter
//   > push to the translated empty string the shifted letter found
//      <=> the shifted letter is found by using bracket notation to subset either
//        an uppercase alphabet constant array or a lowercase constant array w/
//        the index derived from the prior step
//   > add 1 to the number keyword index points to and check if keyword index points
//     to a number greater than its max index value <=> if it does then reassign
//     the keyword index to 0 (this should happen before the next iteration begins)
//       <=> only add 1 to the keword index if the character being iterated over is
//          a letter
// vi. return the translated string
function vigenereCipher(plaintext, keyword) {
  const UPPER_ABCS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const LOWER_ABCS = 'abcdefghijklmnopqrstuvwxyz';
  let translatedText = '';
  let keyIdx = 0;
  keyword = keyword.toUpperCase();
  let key;

  plaintext.split('').forEach(char => {
    if (char.match(/[A-Z]/)) {
      key = UPPER_ABCS.indexOf(keyword[keyIdx]);
      translatedText += encrypt(char, key, UPPER_ABCS);
      keyIdx = (keyIdx + 1) % keyword.length;
    } else if (char >= 'a' && char <= 'z') {
      key = UPPER_ABCS.indexOf(keyword[keyIdx]);
      translatedText += encrypt(char, key, LOWER_ABCS);
      keyIdx = (keyIdx + 1) % keyword.length;
    } else {
      translatedText += char;
    }
  });

  return translatedText;
}

function encrypt(letter, key, alphabet) {
  const letterPos = alphabet.indexOf(letter);

  for (let step = 1; step <= key; step += 1) {
    if (!alphabet[letterPos + step]) {
      alphabet += alphabet;
    }

    letter = alphabet[letterPos + step];
  }

  return letter;
}

//Applying the Vigenere Cipher for each alphabetic character:
//plaintext : Pine appl esdo ntgo onpi zzas
//shift     : meat meat meat meat meat meat
//ciphertext: Bmnx mtpe qwdh zxgh arpb ldal

vigenereCipher("Pineapples don't go on pizzas!", "meat");
// result: Bmnxmtpeqw dhz'x gh ar pbldal!


// Problem:
// write a function that displays an 8-pointed star in an nxn grid

// data:
// input: n is an odd integer argument, the smallest n is 7
// output: log to the console a star created via star characters
//   and spaces

// n === 7:
// first row: *, space, space, star, space, space, star
// second row: space, *, space, *, space, *, space
// third row: 2 spaces, 3 stars, 2 spaces
// fourth row/middle row: 7 stars
// fifth row: is same as 3rd row
// sixth row: is same as 2nd row
// 7th row: is same as 1st row

// logic/data structure:
// > store rows in an array
// > all rows except the middle row have 3 stars no matter what n is
// > there are fewer spaces between stars in a non-middle row, the closer
//     you get to the middle row
// > number of spaces = n - 3 
//     > odd number minus 3 is always an even number
// > 1st row:
//     * + ' '.repeat((n - 3)/2) + * + ' '.repeat((n - 3)/2) + '*'
//  > 2nd row: 
//    ' ' + * + ' '.repeat((n - 3 - 2)/2) + * + ' '.repeat((n - 3 - 2)/2)) + '*' + ' '
// > 3rd row:
//    ' '.repeat(2) + '*' + ' '.repeat((n - 3 - 2 - 2)/2) + '*' + ' '.repeat((n - 3 - 2 - 2)/2) + '*' + ' '

// incremental logic for a row:
// row 1:
//   let initialEndingSpaces = 0;
//   let middleSpacesNumerator = n - 3;
//   let middleSpaces = middleSpacesNumerator / 2;

// row 2:
//   initialEndingSpaces += 1;
//   let middleSpacesNumerator -= 2;
//   middleSpaces = middleSpacesNumerator / 2;

// row 3:
//   initialEndingSpaces += 1;
//   let middleSpacesNumerator -= 2;
//   middleSpaces = middleSpacesNumerator / 2;

// ...
// middle row:
// n number of stars <=> '*'.repeat(n);

// finding the middle row:
// Math.ceil(n / 2);

// Algorithm:
// i. declare initialEndingSpaces to zero, the middleSpacesNumerator to n - 3, and
//  the middleSpaces to middleSpacesNumerator / 2
// ii. declare an array to store individual rows up through & exclusive of the middle row
// iii. iterate from 1 to n / 3 - 2 floored and on each iteration derive the
//     space and star pattern string row:
//     ' '.repeat(initialEndingSpaces) + * + ' '.repeat(middleSpaces) + * + 
//           ' '.repeat(middleSpaces) + '*' + ' '.repeat(initialEndingSpaces)
//     <=> this derives all the rows w/ only 3 stars
//    > after deriving the row and pushing the row to the array, subtract
//       2 from the number middleSpacesNumerator points to and add 1
//        to the number initialEndingSpaces points to and then rederive
//        middleSpaces as middleSpacesNumerator / 2
// iv. iterate through the array of rows and log each value to the console
// v. log to the console the middle row which has n number of stars repeated
// vi. log to the console the elements of the array in reversed order
function star(n) {
  let initialEndingSpaces = 0;
  let middleSpacesNumerator = n - 3;
  let middleSpaces = middleSpacesNumerator / 2;
  let rows = [];

  for (let rowNum = 1; rowNum <= Math.ceil((n - 3) / 2); rowNum += 1) {
    rows.push(createRow(initialEndingSpaces, middleSpaces));

    initialEndingSpaces += 1;
    middleSpacesNumerator -= 2;
    middleSpaces = middleSpacesNumerator / 2;
  }

  let threeStarRow = ' '.repeat((n - 3) / 2) + '***' + ' '.repeat((n - 3) / 2);
  rows.push(threeStarRow);

  printStarRow(rows);
  printStarRow(['*'.repeat(n)]);
  printStarRow(rows.reverse());
}

function createRow(initialSpaces, middleSpaces) {
  let outerSpace = ' '.repeat(initialSpaces);
  let innerSpace = ' '.repeat(middleSpaces);

  return outerSpace + '*' + innerSpace + '*' +
    innerSpace + '*' + outerSpace;
}

function printStarRow(rows) {
  rows.forEach(row => console.log(row));
}

// test cases:
star(7);
// logs
//*  *  *
// * * *
//  ***
//*******
//  ***
// * * *
//*  *  *

star(9);
// logs
//*   *   *
// *  *  *
//  * * *
//   ***
//*********
//   ***
//  * * *
//*  *  *
//*   *   *

// Problem:
// Data:
// input: string
// output: string that indicates if the number is valid or not according to the luhn
//    formula

// requirements:
// > can ignore all non-numeric characters in the given string argument
// > This number must pass the following test:
//     > from right to left, double the value of every second digit 
//         <=> first digit to double is located at the length - 2 idx position of
//              the corresponding string
// > For any digit the becomes 10 or more, subtract 9 from the result
//       1111 becomes 2121
//       8763 becomes 7733 
//          <=> 2 x 6 = 12 -> 12 - 9 = 3 
//          <=> 2 x 8 = 16 -> 16 - 9 = 7
// > Add all these digits together to calculate the checksum
//     1111 becomes 2121 sums as 2 + 1 + 2 + 1 to give a checksum of 6
//     8763 becomes 7733, and 7 + 7 + 3 + 3 is 20
// > If the checksum ends in 0 then the number is valid according to the Luhn Formula
//     > otherwise, it is not valid
//        >> 1111 is not valid (it comes out to 6), 
//        >> 8763 is valid (it comes out to 20)

// algorithm:
// i. select all numeric characters and reverse the characters
// ii. map the selected reversed characters and transform each character to a number
//   and if the index is odd of the character then multiply its number form by 2
// iii. sum all the mapped numbers to calc the checksum
// iv. check if the last digit of the checksum is 0 or not
//      > can us a ternary statement that returns 'valid' if the last digit is 0
//        or 'invalid' otherwise
function luhn(str) {
  let digits = str.split('').filter(char =>
    char.match(/\d/)).reverse();
  
  digits = digits.map((num, idx) => {
      num = Number(num);
      if (idx % 2 !== 0) {
        num *= 2;
      }
      return num >= 10 ? num - 9 : num;
    });
  
  let checksum = sum(digits);
  let end = lastDigit(checksum);

  return end === "0" ? 'valid' : 'invalid';
}

function sum(nums) {
  return nums.reduce((total, num) =>
    total + num);
}

function lastDigit(num) {
  let str = String(num);
  return str[str.length - 1];
}

luhn("2323 2005 7766 3554"); // valid
luhn("1111"); // invalid
luhn("8763"); // valid
luhn("8763A"); // valid

// Problem:
// Data:
// input: array of numbers  (at least 1 number)
// output: array of numbers that inicate the counts of all the
//    other numbers that are smaller than it that exist in the given array

// requirements:
// > only count unique values
// > returned array should list the counts for duplicate numbers as many
//    time as that duplicate occurs

// Algorithm:
// i. find all the unique numbers in the given array
// ii. push each number as a key in an object that will store the count
// iii. find the appropriate value for each key
//      > iterate through the array of unique numbers and filter to all 
//         numbers that are less than the number value of the key being
//         considered
//      > find the length of the array returned from filtering
//      > assign the length as the value associated with the string key
// iv. iterate through the given array and look up the count value
//      associated with the string from the object
// v. return the mapped array
function smallerNumsThanCurrent(arr) {
  let uniqueNums = unique(arr);
  let counts = {};

  uniqueNums.forEach(key => {
    counts[key] = numValsLessThan(key, uniqueNums);
  });

  return arr.map(num => counts[num]);
}

function numValsLessThan(value, nums) {
  return nums.filter(num => num < value).length;
}

function unique(array) {
  let uniqueVals = [];

  array.forEach(element => {
    if (!uniqueVals.includes(element)) {
      uniqueVals.push(element);
    }
  });

  return uniqueVals;
}

// test cases:
smallerNumsThanCurrent([8,1,2,2,3]);            // [3, 0, 1, 1, 2]
smallerNumsThanCurrent([1,4,6,8,13,2,4,5,4]);   // [0, 2, 4, 5, 6, 1, 2, 3, 2]
smallerNumsThanCurrent([7,7,7,7]);              // [0,0,0,0]
smallerNumsThanCurrent([6,5,4,8]);              // [2, 1, 0, 3]
smallerNumsThanCurrent([1]);                   // [0]

// Problem:
// Data:
// input: array of integers
// output: the minimum sum of 5 consecutive numbers in the array

//  requirements:
//   > return null if the array contains < 5 elements or any non numbers

// Algorithm:
// i. filter the given array to all elements that when converted to string
//   characters, they match a numerical digit
// ii. find the length of the filtered array and if it's not >= 5 and equivalent
//     to the length of the given array then return null
// iii. find all consecutive sequences of 5 numbers
//      > find the index that is 4 elements away from the ending index
//          let maxIdx = arr.length - 1;
//          let lastSliceStartingIdx = maxIdx - 4;
//      > iterate from 0 up to the lastSliceStartingIdx and on each iteration:
//         > slice the given array starting at the index being iterated over
//          and with a length of 5 elements (so 2nd argument of slice 
//          should be 6)
//         > push each slice as a subarray to an array of all consecutive 5 digits
// iv. map over all subarrays and find the sum of all the numbers in the subarray
// v. filter to the smallest sum and return this value

function minSum(arr) {
  if (!validArrOfNums(arr)) {
    return null;
  }

  let maxIdx = arr.length - 1;
  let lastSliceStartingIdx = maxIdx - 4;
  let slices = [];

  for (let idx = 0; idx <= lastSliceStartingIdx; idx += 1){
    let IdxFirstElementToExclude = idx + 5;
    slices.push(arr.slice(idx, IdxFirstElementToExclude));
  }

  return min(slices.map(sumOfFives));
}

function min(arr) {
  return arr.reduce((num1, num2) => {
    if (num1 < num2) {
      return num1;
    } else {
      return num2;
    }
  });
}

function sumOfFives(arr) {
  return arr.reduce((total, num) => total + num);
}

function validArrOfNums(arr) {
  let digits = arr.filter(element => 
    String(element).match(/\d/));

  return digits.length === arr.length && arr.length >= 5;
}

minSum([1, 2, 3, 4]);       // null
minSum([1, 2, 3, 4, 5, 6]); // 15
minSum([55, 2, 6, 5, 1, 2, 9, 3, 5, 100]); // 16
minSum([-1, -5, -3, 0, -1, 2, -4]); // -10


// Problem:
// Data:
// input: string letters
// output: same sequence of characters with every 2nd character in
//    every 3rd word converted to uppercase

// requirements:
// word: separated by single bases and consists of only alphabetical letters
// strings will always contain at least one word

// Algorithm:
// i. split the given string into words by splitting at single spaces
// ii. iterate through the every 3rd word
//   > first word is at the 0th index
//   > every 3 word indices = 2, 5, 8, 11... 
// iii. replace every 3rd word with its mapped string word
//      > split the word into its characters
//      > map the characters
//         > if the character's idx is odd, then capitalize the letter at that index
//         > if the character's idx is not odd, then leave the letter as is
//      > join the characters together to find the translated word
//      > reassign the word at the array's index that's currently being iterated over
//        to the translated word
// iv. join with spaces all the words in the array
function toWeirdCase(str) {
  let words = str.split(' ');
  
  for (let idx = 2; idx < words.length; idx += 3) {
    let word = words[idx];
    let mappedWord = upperEverySecondChar(word);
    
    words[idx] = mappedWord;
  }

  return words.join(' ');
}

function upperEverySecondChar(word) {
  let chars = word.split('');
  
  return chars.map((char, idx, arr) => {
    if (idx % 2 !== 0) {
      return char.toUpperCase();
    } else {
      return char;
    }
  }).join('');
}


toWeirdCase('Lorem Ipsum is simply dummy text of the printing'); 
// 'Lorem Ipsum iS simply dummy tExT of the pRiNtInG'

toWeirdCase('It is a long established fact that a reader will be distracted'); 
// 'It is a long established fAcT that a rEaDeR will be dIsTrAcTeD'
  
toWeirdCase('aaA bB c'); // 'aaA bB c'

toWeirdCase('Miss Mary Poppins word is supercalifragilisticexpialidocious'); 
//'Miss Mary POpPiNs word is sUpErCaLiFrAgIlIsTiCeXpIaLiDoCiOuS'


// Problem:
// Data:
// input: array of integers
// output: 2 numbers that are closest together in value returned in an array

// requirements:
// > if there are 2 cases of the same difference in value, then return a subarray
// that has the pair of numbers that appear first in the string
// > can assume all inputs will be arrays of 2 or more integers

// Algorithm:
// i. find all unique possible pairs of numbers of the given array
//    > declare a new array to store pairs <=> assign it to an empty array
//    > iterate through each number in the given array and on each iteration:
//       > iterate through the remaining numbers in the array
//          > can create a for loop where the starting idx is 1 plus the idx of 
//              the number in the outer loop
//          > the inner loop should loop while it's less than the length of the given array
//          > create a subarray where the first element is the outer number being iterated
//            over and the second element is the inner loop's current number being iterated
//            over
//          > check if the declared array that stores pairs already includes the subarray pair
//              > if it does then don't add the subarray to it, if it doesn't then push
//                the pair to the array of pairs
// ii. iterate over the array of pairs and map the subarrays via the following:
//         > find the difference between the 2 numbers in the pair
//             > find the max of the 2 numbers in the pair and the min of the 2 numbers in the pair
//             > difference = max - min
//         > store the difference as the 2nd element of each subarray <=> so push to the end
//           of the subarray
// iii. sort the subarrays based on the size of the 3rd element in each subarray
//       > specifically, I want to order the subarrays based on the smallest difference
//          > in the callback, I want to return a negative value if the subarray1 has a smaller
//             3rd element than subarray2
// iv. extract out the first element of the sorted array and return a slice of that subarray
//       element from the 0th index to the 2nd index (the 2nd index is excluded)
function closestNums(arr) {
  let pairs = uniquePairs(arr);
  
  let pairsDiffs = pairs.map(pair => {
    let diff = difference(pair);
    pair.push(diff);
    return pair;
  });

  pairsDiffs.sort((pair1, pair2) => {
    if (pair1[2] < pair2[2]) {
      return -1;
    } else if (pair1[2] > pair2[2]) {
      return 1;
    } else {
      return -1;
    }
  });

  return pairsDiffs[0].slice(0, 2);
}

function difference(nums) {
  let max = nums[0] >= nums[1] ? nums[0] : nums[1];
  let min = nums[0] < nums[1] ? nums[0] : nums[1];

  return max - min;
}

function uniquePairs(arr) {
  let pairs = [];

  arr.forEach((num, outerIdx, arr) => {
    for (let innerIdx = outerIdx + 1; innerIdx < arr.length; innerIdx += 1) {
      let pair = [num, arr[innerIdx]];

      if (!pairs.includes(pair)) {
        pairs.push(pair);
      }
    }
  });

  return pairs;
}

// test cases:
closestNums([5, 25, 15, 11, 20]);      // [15, 11]
closestNums([19, 25, 32, 4, 27, 16]); // [25, 27]
closestNums([12, 7, 17]);            // [12, 7]
closestNums([12, 7, 1, 17, 22]);     // [12, 7]

// Problem:
// Data:
// input: string argument with at least one character
// output: 
//    > character that occurs least often in the given string
//    > If there are multiple characters with the equal lowest number
//       of occurrences, then return the one that appears first in the
//        string

// Requirements:
// characters are not case sensitive 

// Algorithm:
// > declare an object whose keys will be individual characters and the
//     values will be the count of the number of times the character
//     occurs in the string
// > iterate through the characters of the string and on each iteration:
//     > check if the lowercased character already is a key in the object
//        > if it is then add 1 to the corresponding value
//        > if it's not then establish it as a key and assign it to a value of 1
// > sort the object's values from smallest to largest
// > from the sorted array of values, I want to select the smallest count
//     which after sorting is the element at the 0th index
// > iterate through the characters of the given string and check if the
//     lowercased character key's associated value in the object of counts
//     is equivalent to the smallest count previously found
//       > if the values are equivalent then stop iterating and return
//         the current character being iterated over
function leastCommonChar(string) {
  let counts = charCounts(string);
  let smallestCount = Object.values(counts).sort(ascendingOrder)[0];

  for (let idx = 0; idx < string.length; idx += 1) {
    let key = string[idx].toLowerCase();
    
    if (counts[key] === smallestCount) {
      return string[idx];
    }
  }
  
}

function ascendingOrder(num1, num2) {
  if (num1 < num2) {
    return -1;
  } else if (num1 > num2) {
    return 1;
  } else {
    return 0;
  }
}

function charCounts(str) {
  let counts = {};

  str.split('').forEach(char => {
    let key = char.toLowerCase();

    if (Object.keys(counts).includes(key)) {
      counts[key] += 1;
    } else {
      counts[key] = 1;
    }
  });

  return counts;
}

// test cases:
leastCommonChar("Hello World");   // "H"
leastCommonChar("Peter Piper picked a peck of pickled peppers"); // "t"
leastCommonChar("Mississippi");   // "M"
leastCommonChar("Happy birthday!");  // ' '
leastCommonChar("aaaaaAAAA");       // 'a'
