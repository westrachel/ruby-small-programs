// 1. Calculate Average Score Based on User Inputs
// can assume input values are integers
const NUMBER_OF_SCORES = 3;
let total = 0;
let count = 1;

do {
  let string = 'Enter Score ' + String(count) + ':';
  let score = prompt(string);
  let numScore = Number(score);

  if (numScore > 0) {
    total += numScore;
    count += 1;
  } else {
    alert('Please enter your score again with a valid positive integer.');
  }

} while (count < 4);

let avg = total / 3;

function findGrade(avgScore) {
  if (avgScore >= 90) {
    return '"A".';
  } else if (avgScore >= 70) {
    return '"B".';
  } else if (avgScore >= 50) {
    return '"C".';
  } else {
    return '"F".';
  }
}

let MSG_1 = 'Based on the average of your 3 scores your letter grade is ';
console.log(MSG_1 + findGrade(avg));

// 2. Pattern Generation
// write a function that takes an integer argument and logs a rectangular
//  shape of incrementing number sequences and stars

// Example:
// generatePattern(7);
// console output
// 1******
// 12*****
// 123****
// 1234***
// 12345**
// 123456*
// 1234567

function generatePattern(num) {
  let nStars = num - 1;
  let endNum = 1;

  while (nStars >= 0) {
    let nums = Array(endNum).fill(1).map((_, number) => number + 1);
    let row =  nums.join('') + '*'.repeat(nStars);

    console.log(row);
    endNum += 1;
    nStars -= 1;
  }
}

generatePattern(10);

// 3. Trimming Spaces
// write a function that returns the front and ending spaces from a string
//   do not remove internal spaces
// approach:
// > initialie an array with -1
// > loop through the string's characters and:
//     > check if each character is a whitespace character or not
//     > if it's not a whitespace than add the character's index position
//         to the index array
// > check if the index array's length is greater than 1
// > if the array's length is greater than 1 then reassign the indices array
//     to an array of 2 values that correspond with the smallest index
//     and largest index of the string that correspond with non-whitespaces
// > return an empty string if the index returned from the function written
//    to handle all previous steps has a length of 1 (that means that the
//     string argument only has whitespaces, so an empty string should be
//     returned)
// > otherwise, return a slice of the string argument of all the characters
//   between the index that corresponds with the first nonspace character
//    and the last nonspace character
function leadingTrailingNonSpaceIndices(string) {
  let indices = [-1];

  for (let index = 0; index < string.length; index += 1) {
    if (!string[index].match(/\s/)) {
      indices.push(index);
    }
  }
  if (indices.length > 1) {
    indices.shift();
    let max = Math.max(...indices) + 1;
    let min = Math.min(...indices);
    indices = [min, max];
  }

  return indices;
}

function trim(string) {
  let indices = leadingTrailingNonSpaceIndices(string);

  if (indices.length === 1) {
    return "";
  } else {
    return string.slice(indices[0], indices[1]);
  }
}

trim('  abc  ');  // "abc"
trim('abc   ');   // "abc"
trim(' ab c');    // "ab c"
trim(' a b  c');  // "a b  c"
trim('      ');   // ""
trim('');         // ""

// 4. Splitting a String
// write a function that logs all substrings of a string that are delimited
// by the second argument that's passed into the function (the first argument
// is the string to find substrings of)
// requirements:
//  > only use brackets and length property
//  > if a second argument isn't supplied log 'ERROR: no delimiter'
//  > do not log the delimiter as part of the substring

// approach:
// > check if the second argument is the default value that's set to the error
//     message & if it is then log that error to the console
// > if the delimiter is an empty string, then iterate through all the characters
//   of the first argument and pass each character as an argument to the console.
//    log call
// > find the index positions of the string that correspond with characters that
//    are equivalent to the delimiter and store all these values in an array
//    > initialize an array to start that contains -1 as the first index delimiter
//        value
//    > loop through the passed in string and compare each character at every index
//        to the delimiter and if there is equivalence then add that character's
//         index to the array of indices
//    > after the loop push to the array the length of the string
// > create an outer loop that will iterate through all the index positions of
//    the array of delimiter indices previously found
//  > for each iteration, initialize a substring variable to an empty string,
//       and initialize a starting substring index and an ending substring index
//       that are equivalent to the integer values of the delimiter Index array
//       located at the current array index being iterated over and the array index
//       directly right adjacent to the current array index
//      > loop through all the characters located at indices between the start index
//         previously found and the ending index previously found and add these
//         characters to a substring
//     > log the substring 
//     > break the outer loop if the ending index is undefined (aka out of bounds), 
//        which means there are no more substrings to find
function delimiterIndices(string, delimiter) {
  let indices = [-1];

  for (let index = 0; index < string.length; index += 1) {
    if (string[index] === delimiter) {
      indices.push(index);
    }
  }

  indices.push(string.length);

  return indices;
}

function splitString(string, delimiter = 'ERROR: No delimiter') {
  let delimIndices = delimiterIndices(string, delimiter);

  if (delimiter === 'ERROR: No delimiter') {
    console.log(delimiter);

  } else if (delimiter === '') {
    for (let index = 0; index < string.length; index += 1) {
      console.log(string[index]);
    }

  } else {
    for (let arrIndex = 0; arrIndex < delimIndices.length; arrIndex += 1) {
      let substring = '';
      let startIndex = delimIndices[arrIndex] + 1;
      let endIndex =  delimIndices[arrIndex + 1];

      if (endIndex === undefined) {
        break;
      }

      for (let index = startIndex; index < endIndex; index += 1) {
        substring += string[index];
      }
    
      console.log(substring);
    }
  }
}

splitString('hello'); // logs: ERROR: No delimiter
splitString('hello', '');
// logs:
// h
// e
// l
// l
// o

splitString('hello', ';');
// logs:
// hello

splitString(';hello;', ';');
// logs:
//  (blank line)
// hello

splitString('abc,123,hello world', ',');
// logs:
// abc
// 123
// hello world

// 5. Repeating a String
// write a function that repeats a string (first argument) the number of times
// specified by the second argument
// requirements:
//   > if second argument is negative or is anything besides a positive integer,
//    return undefined
//   > can only use string concatenation
function repeat(string, times) {
  if (typeof times === "number" && times > 0) {
    let repeatedStr = '';

    for (let counter = 0; counter < Math.round(times); counter += 1) {
      repeatedStr += string;
    }

    return(repeatedStr);
  }
}

repeat('abc', 1);       // "abc"
repeat('abc', 2);       // "abcabc"
repeat('abc', -1);      // undefined
repeat('abc', 'a');     // undefined
repeat('abc', false);   // undefined
repeat('abc', null);    // undefined
repeat('abc', '  ');    // undefined

// 6. String Starts With
// write a function that returns a boolean that specifies whether the first
// string argument starts with the second string argument or not
function startsWith(string, searchString) {
  let numMatches = 0;
  for (let index = 0; index < searchString.length; index += 1) {
    if (string[index] === searchString[index]) {
      numMatches += 1;
    }
  }

  if (numMatches === searchString.length || searchString === '') {
    return true;
  } else {
    return false;
  }
}

let str = 'We put comprehension above all else';
startsWith(str, 'We');              // true
startsWith(str, 'We put');          // true
startsWith(str, '');                // true
startsWith(str, 'put');             // false

let longerString = 'We put comprehension above all else!';
startsWith(str, longerString);      // false

// refactored solution:
function beginsWith(string, searchString) {
  for (let idx = 0; idx < searchString.length; idx += 1) {
    if (string[idx] === searchString[idx]) {
      return false;
    }
  }

  return true;
}

// 7. Converting String to Lowercase via ASCII table lookups
// approach:
// > initialize an empty lower case string (to be returned by the function)
// > iterate through each of the characters in the string argument
// > based on the ascii table, uppercase letters have numeric codes ranging
//  from 65 - 90, so if the numeric conversion of a given character is
//  outside of that range, then push the character of the string being
//  iterated over as is to the lower case string; otherwise push the
//  lower case version of the string using the ascii table numeric conversion
function toLowerCase(string) {
  const CONVERSION_REQ_UPPER_BOUND = 90;
  const CONVERSION_REQ_LOWER_BOUND = 65;
  const ASCII_CONVERSION_ADDEND = 32;
  let lowerCaseStr = '';

  for (let index = 0; index < string.length; index += 1) {
    let asciiNum = string.charCodeAt(index);

    if (asciiNum >= CONVERSION_REQ_LOWER_BOUND && asciiNum <= CONVERSION_REQ_UPPER_BOUND) {
      asciiNum += ASCII_CONVERSION_ADDEND;
      lowerCaseStr += String.fromCharCode(asciiNum);
    } else {
      lowerCaseStr += string[index];
    }
  }

  return lowerCaseStr;
}

toLowerCase('ALPHABET');  // "alphabet"
toLowerCase('123');       // "123"
toLowerCase('abcDEF');    // "abcdef"

// 8. Substring Pt 1
// write a function that returns a substring based on subsetting the given 
// string w/ the index & length arguments

// requirements:
// > negative lengths are possible but should return an empty string in those
//    cases
// > length can be greater than the string's length, but there should be no
//    circular looping over the string to account for the longer length argument
//    <=> just return a substring that goes until the end of the given string
//       if the length argument exceeds the length of the given string

// approach:
// > assign a starting index variable that is equal to the 2nd argument unless the
//   2nd argument is negative, in which case the variable should equal the 2nd
//   argument plus the 1st string argument's length
// > find the ending index of the substring
//    > need to cap the ending index at the largest index available, which is found
//       by substracting 1 from the string's length
//    > the ending index, if not capped, should be equal to the index variable's value
//       previously found plus the length 3rd argument passed in minus 1
// > initialize a variable whose value is an empty string
// > iterate through the characters in the string starting from the index position that
//    corresponds with the index variable's integer value to the index position that
//    corresponds with the ending index variable's value
//     > on each iteratin push the string argument's character at the current index
//        position to the substring
function substr(string, start, length) {
  let index = (start < 0 ? string.length + start : start);
  let endIndex = Math.min(...[index + length - 1, string.length - 1]);
  let substring = '';

  while (index <= endIndex) {
    substring += string[index];
    index += 1;
  }

  return substring;
}

substr('hello world', 2, 4);     // "llo "
substr('hello world', -3, 2);    // "rl"
substr('hello world', 8, 20);    // "rld"
substr('hello world', 0, -20);  // ""
substr('hello world', 0, 0);    // ""

// 9. Substring Pt 2
// write a function that returns a substring of the given string argument
// requirements:
// > if start & end arguments are positive & start < end & both indices are
//     in bounds for the given string, then return the substring from the
//     [start index, end index)
// > if start > end, then return the string [end index, start index)
// > if start === end, return an empty string
// > if end argument isn't provided then return the substring from the start
//    index through to the end of the string
// > if start or end are less than 0 or isn't a number then treat them as 0
// > if start or end are greater than the length of the string, treat them as
//     equal to the string length
function prepIndex(length, index) {
  if (index > length || index === undefined) {
    return length;
  } else if (index < 0 || typeof index !== "number") {
    return 0;
  } else {
    return index;
  }
}

function substring(string, start, end) {
  let startIdx = prepIndex(string.length, start);
  let endIdx = prepIndex(string.length, end);

  let trueStart = Math.min(...[startIdx, endIdx]);
  let trueEnd = Math.max(...[startIdx, endIdx]);

  if (trueStart !== trueEnd) {
    return string.slice(trueStart, trueEnd);
  } else {
    return "";
  }

}

substring('hello world', 2, 4);    // "ll"
substring('hello world', 4, 2);    // "ll"
substring('hello world', 0, -1);   // ""
substring('hello world', 2);      // "llo world"
substring('hello world', 'a');    // "hello world"
substring('hello world', 8, 20);   // "rld"

// 10. Rot13
// write a function, rot13, that takes a String and returns that string transformed
//   by the ro13 cipher
// requirements:
// > if character is a letter in the modern English alphabet, change it to the
//  character 13 positions later in the alphabet
//     > ex: a becomes n
// > if reach end of the alphabet, return to the beginning (so o, becomes b)
// > letter transformations should preserve case (A -> N, a -> n)
// > don't modify characters that are not letters

// approach:
// > uppercase letters in ascii table correspond with the numeric codes:
//      [65, 90] ("A" -> "Z")
// > lowercase letters in ascii table correspond with the numeric codes:
//      [97, 122] ("a" -> "z")
// > initialize a translated string variable with an empty string that converted
//    characters will be pushed to (or non-converted non-alphabetical characters will
//    be pushed to)
// > iterate through the characters of the given string argument
//     > if the character isn't an alphabetical letter that matches against
//        the regex /[A-Za-z]/ then push the character as is to the translated string
//        variable
//     > if the character does match an alphabetical letter, then establish whether
//        it's uppercased or not
//        > if uppercased, find an array of asciiNumCodes that correspond with "A" -> "Z"
//        > if lowercased, find an array of asciiNumCodes that correspond with "a" -> "z"
//          <=> this array represents the range of acceptable asciiNumCodes that the current
//             character's asciiNumCode shifted 13 places should fall within (***)
//     > initialize a proposed asciiNumCode that corresponds with the asciiNumCode of 
//        the current character being iterated over plus 13
//     > check if the proposed ascii number falls within the range of numbers in the array
//       identified under (***) above
//     > if the proposed ascii number is out of bounds, then find the difference between the
//        proposed ascii number code and the max number in the relevent asciiNumCodes array
//          > subtract 1 from this difference to find the addend amount that should be
//            added onto the minimum number in the array of relevant asciiNumCodes
//     > push to the translated string variable the string character value associated with the
//         prepped proposed asciiNumCode
// > after the loop finishes return the translated string variable's value
function createArrayOfNums(size, startingNumber) {
  return Array(size).fill(0).map((_, num) => num + startingNumber);
}

function shiftLetter(upperOrLower, letter) {
  let proposedAsciiNum = letter.charCodeAt(0) + 13;
  let firstLetter = upperOrLower === 'uppercase' ? 'A' : 'a';
  const ABC_SIZE = 26;

  const RANGE = createArrayOfNums(ABC_SIZE, firstLetter.charCodeAt(0));

  if (RANGE.includes(proposedAsciiNum)) {
    return String.fromCharCode(proposedAsciiNum);
  } else {
    let addend = proposedAsciiNum - Math.max(...RANGE) - 1;
    proposedAsciiNum = Math.min(...RANGE) + addend;
    return String.fromCharCode(proposedAsciiNum);
  }
  
}

function shiftLetterOrStay(letter) {
  if (letter.match(/[a-z]/)) {
    return shiftLetter('lowercase', letter);
  } else if (letter.match(/[A-Z]/)) {
    return shiftLetter('uppercase', letter);
  } else {
    return letter;
  }

}

function rot13(string) {
  let translatedString = '';

  for (let index = 0; index < string.length; index += 1) {
    translatedString += shiftLetterOrStay(string[index]);
  }

  return translatedString;
}

console.log(rot13('Teachers open the door, but you must enter by yourself.'));
// Grnpuref bcra gur qbbe, ohg lbh zhfg ragre ol lbhefrys.

console.log(rot13(rot13('Teachers open the door, but you must enter by yourself.')));
//Teachers open the door, but you must enter by yourself.

// 11. Character Count
// write a function that returns an object of key-value pairs specifying the # of
//  instances of characters in the string argument
// requirements:
// > character counts are returned only for characters with >= 2 instances
// > 'unique characters' are not case-sensitive
// > keys are lowercased versions of the characters
function characterCounts(string) {
  let counts = {};
  for (let idx = 0; idx < string.length; idx += 1) {
    let letter = string[idx].toLowerCase();

    if (Object.keys(counts).includes(letter)) {
      counts[letter] += 1;
    } else {
      counts[letter] = 1;
    }
  }

  return counts;
}

function repeatedCharacters(string) {
  let letterCounts = characterCounts(string);

  for (let letter in letterCounts) {
    if (letterCounts[letter] < 2) {
      delete letterCounts[letter];
    }
  }

  console.log(letterCounts);
  return letterCounts;
}

repeatedCharacters('Programming');    // { r: 2, g: 2, m: 2 }
repeatedCharacters('Combination');    // { o: 2, i: 2, n: 2 }
repeatedCharacters('Pet');            // {}
repeatedCharacters('Paper');          // { p: 2 }
repeatedCharacters('Baseless');       // { s: 3, e: 2 }

// 12. Concatenation
// write a function that accepts 2 string arguments and 
// deterimines the shorter of the 2 strings and then
// returns the shorter string concatenated w/ the longer
// string concatenated again w/ the shorter string
// can assume varying lengths
function shortLongShort(str1, str2) {
  let short = str1.length < str2.length ? str1 : str2;
  let long = short === str1 ? str2 : str1;

  return short + long + short;
}

shortLongShort('abc', 'defgh');    // "abcdefghabc"
shortLongShort('', 'xyz');         // "xyz"

// 13. UTF-16 String Value
function utf16Value(string) {
  let total = 0;

  for (let index = 0; index < string.length; index += 1) {
    total += string.charCodeAt(index);
  }

  return total;
}
utf16Value('Four score');         // 984
utf16Value('Launch School');      // 1251
utf16Value('a');                  // 97
utf16Value('');                   // 0

// 13. De-duplicate consecutives
// write a function that removes duplicate instances of
// the same consecutive character
function crunch(string) {
  let deDupped = '';

  for (let index = 0; index < string.length; index += 1) {
    let prior = string[index - 1];
    let current = string[index];
    
    if (current != prior) {
      deDupped += current;
    }
  }

  return deDupped;
}
crunch('ddaaiillyy ddoouubbllee');    // "daily double"
crunch('4444abcabccba');              // "4abcabcba"
crunch('ggggggggggggggg');            // "g"
crunch('a');                          // "a"
crunch('');                           // ""

// 14. Binary
// write a function that returns a string of 1s and 0s
// whose length matches the number argument
function stringy(number) {
  const EVEN = "1";
  const ODD = "0";
  let binaryString = '';

  for (let index = 0; index < number; index += 1) {
    if (index % 2 === 0) {
      binaryString += EVEN;
    } else {
      binaryString += ODD;
    }
  }

  return binaryString;
}
stringy(6);    // "101010"

// 15. Doubles
// write a function that returns 2x the argument input
// or returns the number as is if it's a double number
function twice(num) {
  let strNum = String(num);
  let half1 = strNum.split('').slice(0, strNum.length / 2).join('');
  let half2 = strNum.split('').slice(strNum.length / 2, strNum.length).join('');

  let value = (half1 == half2 ? num : 2 * num);
  return value;
}

twice(37);          // 74
twice(44);          // 44
twice(103103);      // 103103
twice(3333);        // 3333
twice(7676);        // 7676

// 16. String CleanUp
// write a function that takes a string and replaces all non-alphabetic
// characters with space characters
// requirement: there shouldn't be 2 consecutive space characters
function cleanUp(string) {
  let preppedStr = '';

  for (let idx = 0; idx < string.length; idx += 1) {
    let last = idx === 0 ? 'a' : string[idx - 1];
    let current = string[idx];

    if (current.match(/[A-Za-z]/)) {
      preppedStr += current; 
    } else if (last.match(/[A-Za-z]/) != null) {
      preppedStr += ' ';
    }
  }

  return preppedStr;
}
cleanUp("---what's my +*& line?");  // " what s my line "

// 17. Palindrome Part 1
// write a function that returns a boolean indicating whether or not the
// passed in string is a palindrome (case matters)
function isPalindrome(string) {
  let midIdx;
  let endIdx = string.length - 1;

  if (string.length % 2 !== 0) {
    midIdx = Math.floor(string.length / 2);
  } else {
    midIdx = string.length - 2;
  }

  for (let idx = 0; idx <= midIdx; idx += 1) {
    if (string[idx] != string[endIdx]) {
      return false;
    }

    endIdx -= 1;
  }

  return true;
}
isPalindrome('madam');      // true
isPalindrome('Madam');      // false (case matters)
isPalindrome("madam i'm adam");      // false (all characters matter)
isPalindrome('356653');     // true
isPalindrome('maddam');     // true
isPalindrome('racecar');    // true

// 18. Palindrome Part 2
// write a function that checks for valid palindromes that ignores
// the case of characters and that ignores non-alphanumeric characters
function isRealPalindrome(string) {
  let stringToCheck = '';

  for (let idx = 0; idx < string.length; idx += 1) {
    if (string[idx].match(/[A-Za-z0-9]/)) {
      stringToCheck += string[idx].toLocaleLowerCase();
    }
  }

  return isPalindrome(stringToCheck);
}

isRealPalindrome('madam');               // true
isRealPalindrome('Madam');               // true (case does not matter)
isRealPalindrome("Madam, I'm Adam");     // true (only alphanumerics matter)
isRealPalindrome('356653');              // true
isRealPalindrome('356a653');             // true
isRealPalindrome('123ab321');            // false

// 19. Letter Swap
// write a function that accepts a string input of words and returns
// a new string that has swapped the first and last letter of each word
// valid assumptions:
// > every word contains at least one letter
// > string will always contain at least one word
// > each string contains nothing but words and spaces
// > there are no leading, trailing, or repeated spaces
function swap(string) {
  let words = string.split(' ');
  let swappedWords = [];

  for (let wordIdx = 0; wordIdx < words.length; wordIdx += 1) {
    let word = words[wordIdx];
    if (word.length > 1){  
      let swappedWord = word[word.length - 1];
      let totalIterations = word.length - 2;
  
      for (let strIdx = 1; strIdx <= totalIterations; strIdx += 1) {
        swappedWord += word[strIdx];
      }
      
      swappedWord += word[0];
      swappedWords.push(swappedWord);
      swappedWord = '';
    } else {
      swappedWords.push(word);
    }
  }

  return swappedWords.join(' ');
}

// refactor using Array.prototype.map
function swapFirstLastCharacters(word) {
  if (word.length === 1) {
    return word;
  }

  return word[word.length - 1] + word.slice(1, -1) + word[0];
}

function swap2(string) {
  let words = string.split(' ');
  let swappedWords = words.map(word => swapFirstLastCharacters(word));

  return swappedWords.join(' ');
}
swap2('Oh what a wonderful day it is');  // "hO thaw a londerfuw yad ti si"
swap2('Abcde');                          // "ebcdA"
swap2('a');                              // "a"

// 20. Letter Counter Part 1
// write a function that accepts a string and returns an object that contains
// counts of the # of words that have specific letter counts
// > a word consist of any sequence of non-space characters
function wordSizes(string) {
  let counts = {};
  let words = string.split(' ');

  for (let idx = 0; idx < words.length; idx += 1) {
    let word = words[idx];
    let key = word.length;

    if (key === 0) {
      continue;
    } else if (counts.hasOwnProperty(String(key))) {
      counts[String(key)] += 1;
    } else {
      counts[String(key)] = 1;
    }
  }

  return counts;
}

wordSizes('Four score and seven.');                       // { "3": 1, "4": 1, "5": 1, "6": 1 }
wordSizes('Hey diddle diddle, the cat and the fiddle!');  // { "3": 5, "6": 1, "7": 2 }
wordSizes("What's up doc?");                              // { "2": 1, "4": 1, "6": 1 }
wordSizes('');                                            // {}

// 21. Letter Counter Part 2
// modify the prior function to exclude non-letters when calculating word size
function scrubWord(word) {
  let scrubbed = '';

  for (let idx = 0; idx < word.length; idx += 1) {
    let letter = word[idx];

    if (letter.match(/[A-Za-z]/)) {
      scrubbed += letter;
    }

  }

  return scrubbed;
}

function strictWordSizes(string) {
  let counts = {};
  let words = string.split(' ');

  for (let idx = 0; idx < words.length; idx += 1) {
    let word = scrubWord(words[idx]);
    let key = word.length;

    if (key === 0) {
      continue;
    } else if (counts.hasOwnProperty(String(key))) {
      counts[String(key)] += 1;
    } else {
      counts[String(key)] = 1;
    }
  }

  return counts;
}

strictWordSizes('Four score and seven.');    // { "3": 1, "4": 1, "5": 2 }
strictWordSizes('Hey diddle diddle, the cat and the fiddle!');  // { "3": 5, "6": 3 }
strictWordSizes("What's up doc?");    // { "5": 1, "2": 1, "3": 1 }
strictWordSizes('');   // {}

// 22. Double Every Character in a Given String
function repeater(string) {
  let doubled = '';

  for (let idx = 0; idx < string.length; idx += 1) {
    doubled += string[idx].repeat(2);
  }

  return doubled;
}
repeater('Hello');        // "HHeelllloo"
repeater('');             // ""

// 24. Double Every Consonant in a String
function doubleConsonants(string) {
  let doubled = '';

  for (let idx = 0; idx < string.length; idx += 1) {
    let char = string[idx];
    if (char.match(/[A-DF-HJ-NP-TV-XZ]/i) ) {
      doubled += char.repeat(2);
    } else {
      doubled += char;
    }
  }

  return doubled;
}

doubleConsonants('String');          // "SSttrrinngg"
doubleConsonants('Hello-World!');    // "HHellllo-WWorrlldd!"
doubleConsonants('July 4th');        // "JJullyy 4tthh"
doubleConsonants('');                // ""

// 23. Return the middle character(s) of a given string
function centerOf(string) {
  if (string.length % 2 == 0) {
    let idx2 = string.length / 2;
    let idx1 = idx2 - 1;
    return string[idx1] + string[idx2];
  } else {
    let index = Math.floor(string.length / 2);
    return string[index];
  }
}
centerOf('I Love JavaScript'); // "a"
centerOf('Hello World');     // " "
centerOf('Launch');            // "un"
centerOf('x');                 // "x"

// 24. Reverse the Words
// > reverse words that are 5 characters or longer
// > words are separated by single spaces
function reverseWords(string) {
  let reversed = '';
  let words = string.split(' ');

  for (let idx = 0; idx < words.length; idx += 1) {
    let word = words[idx];
    reversed += (word.length >= 5 ? word.split('').reverse().join('') : word);

    if (idx + 1 < words.length){
      reversed += ' '; 
    }
  }

  return reversed;
}
reverseWords('Professional');             // "lanoisseforP"
reverseWords('Walk around the block');    // "Walk dnuora the kcolb"

// 25. Octal to Number
// > convert the given string argument from an octal to a decimal
function octalToDecimal(str) {
  let maxPow = str.length - 1;
  let decimals = str.split('').map((x, idx) => Number(x) * (8 ** (maxPow - idx)));
  return decimals.reduce((total, decimal) => total + decimal);
}

octalToDecimal('1');           // 1
octalToDecimal('10');          // 8
octalToDecimal('130');         // 88
octalToDecimal('17');          // 15
octalToDecimal('2047');        // 1063
octalToDecimal('011');         // 9

// 26. write a function that returns a reversed string
// > can't use reverse()
function reverse(string) {
  let chars = string.split('');
  let reversed = [];
  chars.forEach(char => reversed.unshift(char));
  return reversed.join('');
}

reverse('hello');                  // "olleh"
reverse('The quick brown fox');    // "xof nworb kciuq ehT"

// 27. write a function that accepts a string of words that
//  are delimited by space characters or dashes and returns an
// acronym
// approach:
// i. replace all dash characters with single space characters
// ii. split the string at space characters
// iii. iterate over the array of words returned from (i) and map
// aka transform each word into its first letter capitalized
// iv. return a string that has concatenated the capitalized first
//  letter of each word
function acronym(string) {
  let words = string.replace(/\-/g, ' ').split(' ');
  return words.map(word => 
    word[0].toUpperCase()).join('');
}

acronym('Portable Network Graphics');                 // "PNG"
acronym('First In, First Out');                       // "FIFO"
acronym('PHP: HyperText Preprocessor');               // "PHP"
acronym('Complementary metal-oxide semiconductor');   // "CMOS"
acronym('Hyper-text Markup Language');               // "HTML"

// 28. Balanced Parentheses
// write a function that returns a boolean indicating whether
// the passed in string argument has matching parentheses or not
// approach:
// i. iterate through the characters of the given string
// ii. keep count of the # of open and closed parentheses encountered
// iii. if the number of closed parentheses encountered ever exceeds
//  the number of open parentheses encountered then break the loop and
//  return false
// iv. after iteration, compare if the number of open and closed parenthesis
//   counts are the same or not
function isBalanced(string) {
  let counts = { openPar: 0, closedPar: 0, };
  let chars = string.split('');

  for (let idx = 0; idx < chars.length; idx += 1) {
    if (chars[idx] === '(') {
      counts.openPar += 1;
    } else if (chars[idx] === ')') {
      counts.closedPar += 1;
    }
    
    if (counts.closedPar > counts.openPar) {
      return false;
    }
  }

  return counts.openPar === counts.closedPar;
}

isBalanced('What (is) this?');        // true
isBalanced('What is) this?');         // false
isBalanced('What (is this?');         // false
isBalanced('((What) (is this))?');    // true
isBalanced('((What)) (is this))?');   // false
isBalanced('Hey!');                   // true
isBalanced(')Hey!(');                 // false
isBalanced('What ((is))) up(');       // false

// 29. Longest Sentence
// write a function that finds the sentence w/ the most words
// and logs it alongside the # of words it contains
// requirements:
// > sentences can end w/ `.`, `!`, `?`
// > sentences always begin w/ a word character
// > any character that is not a space or sentence-ending character
//    is part of a word
// approach:
// i. declare a variable that points to an empty array that will store
//    individual objects with a sentence property and a word count property
//    and declare a sentence variable that points to an empty string
// ii. iterate over the given text string's characters
// iii. add the character onto the existing string that sentence points to
//    > only add the character if it's not a leading space character 
//    > can check for leading invalid characters by checking if current sentence
//       variable has been reassigned to an empty string and if the current
//       character being iterated over isn't a letter
// iv. if the character added to the string is '!', '.', and '?' then
//    find the sentence string's word count and push the string sentence points
//    to and its  word count as an object to the array declared earlier
// v. reassign the sentence variable to an empty string before beginning
//   the next iteration
// vi. sort the array of objects based on each subobject's word count property
//      > sort largest to smallest
//      > pass to the sort method a comparison function that will:
//          > return -1 if the first object's word count property is larger than
//             the number word count property of the second object (b/c want to
//             sort largest to smallest)
//          > return 1 if the first object's word count property is smaller than the
//             word count property of the second object
//          > return 0 if neither of the prior 2 comparisons evaluated as true (in this
//               case the objects have the same numerical value associated with their
//                numWords property)
// vii. log to the console the string sentence property and the word count property
//    of the first object in the sorted array
function longestSentence(txt) {
  let sentencesWordCounts = findSentencesWordCounts(txt);
  sentencesWordCounts.sort(compareWordCounts);

  let longest = sentencesWordCounts[0];
  console.log(longest.sentence);
  console.log('The longest sentence has ' + longest.numWords + ' words.');
}

function compareWordCounts(obj1, obj2) {
  if (obj1.numWords > obj2.numWords) {
    return -1;
  } else if (obj1.numWords < obj2.numWords) {
    return 1;
  }

  return 0;
}

function findSentencesWordCounts(text) {
  let sentencesWordCounts = [];
  let singleSentence = '';
  let chars = text.split('');

  for (let idx = 0; idx < chars.length; idx += 1) {
    let char = chars[idx];
    char = invalidStartingChar(singleSentence, char) ? '' : char;
    singleSentence += char;

    if (char.match(/[\.!?]/)) {
      sentencesWordCounts.push({
        sentence: singleSentence,
        numWords: wordCount(singleSentence),
      });
      
      singleSentence = '';
    }
  }

  return sentencesWordCounts;
}

function invalidStartingChar(currSentence, currentChar) {
  return currSentence === '' && !currentChar.match(/[A-Z]/i);
}

function wordCount(string) {
  return string.split(' ').length;
}

let shortText = "What's up, 'Doc'?    The brown fox is superlative!";
longestSentence(shortText);

let longText = 'Four score and seven years ago our fathers brought forth' +
  ' on this continent a new nation, conceived in liberty, and' +
  ' dedicated to the proposition that all men are created' +
  ' equal.' +
  ' Now we are engaged in a great civil war, testing whether' +
  ' that nation, or any nation so conceived and so dedicated,' +
  ' can long endure. We are met on a great battlefield of that' +
  ' war. We have come to dedicate a portion of that field, as' +
  ' a final resting place for those who here gave their lives' +
  ' that that nation might live. It is altogether fitting and' +
  ' proper that we should do this.' +
  ' But, in a larger sense, we can not dedicate, we can not' +
  ' consecrate, we can not hallow this ground. The brave' +
  ' men, living and dead, who struggled here, have' +
  ' consecrated it, far above our poor power to add or' +
  ' detract. The world will little note, nor long remember' +
  ' what we say here, but it can never forget what they' +
  ' did here. It is for us the living, rather, to be dedicated' +
  ' here to the unfinished work which they who fought' +
  ' here have thus far so nobly advanced. It is rather for' +
  ' us to be here dedicated to the great task remaining' +
  ' before us -- that from these honored dead we take' +
  ' increased devotion to that cause for which they gave' +
  ' the last full measure of devotion -- that we here highly' +
  ' resolve that these dead shall not have died in vain' +
  ' -- that this nation, under God, shall have a new birth' +
  ' of freedom -- and that government of the people, by' +
  ' the people, for the people, shall not perish from the' +
  ' earth.';

longestSentence(longText);
// logs 86 words + corresponding sentence

let semiLongText = 'Four score and seven years ago our fathers brought forth' +
  ' on this continent a new nation, conceived in liberty, and' +
  ' dedicated to the proposition that all men are created' +
  ' equal.' +
  ' Now we are engaged in a great civil war, testing whether' +
  ' that nation, or any nation so conceived and so dedicated,' +
  ' can long endure. We are met on a great battlefield of that' +
  ' war. We have come to dedicate a portion of that field, as' +
  ' a final resting place for those who here gave their lives' +
  ' that that nation might live. It is altogether fitting and' +
  ' proper that we should do this.' +
  ' But, in a larger sense, we can not dedicate, we can not' +
  ' consecrate, we can not hallow this ground. The brave' +
  ' men, living and dead, who struggled here, have' +
  ' consecrated it, far above our poor power to add or' +
  ' detract. The world will little note, nor long remember' +
  ' what we say here, but it can never forget what they' +
  ' did here. It is for us the living, rather, to be dedicated' +
  ' here to the unfinished work which they who fought' +
  ' here have thus far so nobly advanced.';

longestSentence(semiLongText);
// logs 30 words + corresponding sentence

// 30. write a function that returns a boolean that indicates whether
// all the alphabetical letters in the given string are uppercased or
// not
function isUppercase(string) {
  let letters = string.split('').filter(char => 
    char.match(/[A-Z]/i));

  let upperCased = letters.filter(char =>
    char.match(/[A-Z]/));

  return upperCased.length === letters.length;
}

isUppercase('t');               // false
isUppercase('T');               // true
isUppercase('Four Score');      // false
isUppercase('FOUR SCORE');      // true
isUppercase('4SCORE!');         // true
isUppercase('');                // true

// 31. write a function that takes an array argument of strings and
// returns an array of the same strings scrubbed of vowels
//  vowels: a, e, i, o, u

function removeVowels(array) {
  return array.map(str =>
    str.split('').filter(char =>
      !char.match(/[AEIOU]/i)).join(''));
}

removeVowels(['abcdefghijklmnopqrstuvwxyz'])          // ["bcdfghjklmnpqrstvwxyz"];     
removeVowels(['green', 'YELLOW', 'black', 'white']);  // ["grn", "YLLW", "blck", "wht"]
removeVowels(['ABC', 'AEIOU', 'XYZ']);                // ["BC", "", "XYZ"]


// 32. write a function that takes 1 string argument & returns an object that contains
// 3 properties: 
//   i. the number of lowercase letters in the string,
//   ii. the number of uppercase letters in the string,
// iii. the number of characters that aren't alphabetical letters
function letterCaseCount(string){
  let counts = { lowercase: 0,
                 uppercase: 0,
                 neither: 0, };

  string.split('').forEach(char =>
    updateLetterCaseCounts(char, counts));

  return counts;
}

function updateLetterCaseCounts(character, obj) {
  if (character.match(/[a-z]/)) {
    obj.lowercase += 1;
  } else if (character.match(/[A-Z]/)) {
    obj.uppercase += 1;
  } else {
    obj.neither += 1;
  }

}
letterCaseCount('abCdef 123');  // { lowercase: 5, uppercase: 1, neither: 4 }
letterCaseCount('AbCd +Ef');    // { lowercase: 3, uppercase: 3, neither: 2 }
letterCaseCount('123');         // { lowercase: 0, uppercase: 0, neither: 3 }
letterCaseCount('');            // { lowercase: 0, uppercase: 0, neither: 0 }

// 33. case scrubbing
// ensure the provided string's words each start with a capital letter and
//   all the subsequent characters are lowercased
//  word = any sequence of non-whitespace characters

// approach:
// i. iterate over the characters of the provided string
// ii. if the prior character is a whitespace character or it's the first character
// in the string then capitalize the character
// iii. if the conditions of ii aren't met then lowercase the letter
// iv. join the mapped characters back together and return the joined string
function wordCap(string) {
  let chars = string.split('');
  let preppedChars = [];

  for (let idx = 0; idx < chars.length; idx += 1) {
    let char = chars[idx];
    
    if (idx === 0 || chars[idx - 1].match(/[\s]/)) {
      preppedChars.push(char.toUpperCase());
    } else {
      preppedChars.push(char.toLowerCase());
    }
  }

  return preppedChars.join('');
}

wordCap('four score and seven');       // "Four Score And Seven"
wordCap('the javaScript language');    // "The Javascript Language"
wordCap('this is a "quoted" word');    // 'This Is A "quoted" Word'

// 34. case swapping
// switch the case of each letter in the given string argument
function swapCase(string) {
  return string.split('').map(char => 
    char.match(/[A-Z]/) ? char.toLowerCase() : 
    char.toUpperCase()).join('');
}
swapCase('CamelCase');              // "cAMELcASE"
swapCase('Tonight on XYZ-TV');      // "tONIGHT ON xyz-tv"

// 35. % of types of characters
// Data:
// input: string with at least one character
// output: object w/ 3 properties:
//    i. % of chars in the string that are lowercase letters
//   ii. % of chars that are uppercase letters
//   iii. % of chars that are neither
function letterPercentages(string) {
  let nChars = string.length;
  let pcts = [numChars(string.match(/[a-z]/g)),
              numChars(string.match(/[A-Z]/g)),
              numChars(string.match(/[^a-zA-Z]/g))];
  
  pcts = pcts.map(num => prepPct(num / nChars));

  return {lowercase: pcts[0],
          uppercase: pcts[1],
          neither: pcts[2]};
}

function numChars(match) {
  return match === null ? 0 : match.length;
}

function prepPct(num) {
  let strPct = String(num * 100);
  let decimalIdx = strPct.indexOf(".");
  
  if (decimalIdx === -1 ) {
    strPct += ".00";
  } else {
    let firstPart = strPct.slice(0, decimalIdx);
    let secondPart = strPct.slice(decimalIdx, decimalIdx + 3);
    let thirdDecimal = Number(strPct[decimalIdx + 4]);

    if (secondPart.length === 2) {
      secondPart += "0";
    } else if (thirdDecimal >= 5) {
      let roundUpValue = thirdDecimal + 1;
      secondPart = secondPart.slice(0, 2) + String(roundUpValue);
    }
    
    strPct = firstPart + secondPart;
  }

  return strPct;
}

// test cases:
letterPercentages('abCdef 123');
// { lowercase: "50.00", uppercase: "10.00", neither: "40.00" }

letterPercentages('AbCd +Ef');
// { lowercase: "37.50", uppercase: "37.50", neither: "25.00" }

letterPercentages('123');
// { lowercase: "0.00", uppercase: "0.00", neither: "100.00" }

letterPercentages('aBC');
// { lowercase: "33.33", uppercase: "66.67", neither: "0.00" }