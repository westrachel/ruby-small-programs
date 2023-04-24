// 1. Odd Numbers: 
// write a function to log all odd numbers between 1 & the passed in argument

function logOddNumbers(endpoint) {
  for (let oddNumber = 1; oddNumber <= endpoint; oddNumber += 2) {
   console.log(oddNumber);
  }
}

logOddNumbers(19);

// refactor to check for even numbers and skip all even evaluated numbers
//   using the continue statement
function logOddNums(endpoint) {
  for (let oddNumber = 1; oddNumber <= endpoint; oddNumber += 1) {
   if (oddNumber % 2 === 0) {
     continue;
   }
   console.log(oddNumber);
  }
}

// 2. Multiples
// log string values of the multiples of 3 or 5 for integers from 1 to 100
//   and if it's divisible by both add '!' to the number
function multiplesOfThreeAndFive() {
  let num = 1;
  let max = 100;

  while (num <= max) {
    if (num % 3 === 0 || num % 5 === 0) {
      let stringNum = num % 3 === 0 && num % 5 === 0 ? (String(num) + '!') : String(num);
      console.log(stringNum);
    }
    num += 1;
  }
}

// refactor to define a parameter that the function will find multiples of
// only log the multiples if they are also odd
function findLargestMultiplerLtEq100(factor) {
  let largestMultiple = 100;

  while (largestMultiple % factor !== 0) {
    largestMultiple -= 1;
  }

  return largestMultiple;
}

function logMultiples(factor) {
  let multiple = findLargestMultiplerLtEq100(factor);

  while (multiple >= 0) {
    if(multiple % 2 !== 0) {
      console.log(multiple);
    }
    multiple -= factor;
  }
}

logMultiples(17);
// 85
// 51
// 17

// refactored findLargestMultiplerLtEq100 function that doesn't require a loop
function findLgestMultiplerLtEq100(factor) {
  return Math.floor(100 / factor) * factor;
}

// 3. FizzBuzz
// write a function that iterates over integers from 1 to 100 inclusive and logs
// to the console the integer or Fizz for multiples of 3, Buzz for multiples of
// 5 or FizzBuzz for multiples of 3 and 5
function valueToLog(number) {
  if (number % 3 === 0 && number % 5 === 0) {
    return "FizzBuzz";
  } else if (number % 3 === 0) {
    return "Fizz";
  } else if (number % 5 === 0) {
    return "Buzz";
  } else {
    return number;
  }
}

function fizzbuzz() {
  let num = 1;
  let max = 100;

  while (num <= max) {
    console.log(valueToLog(num));
    num += 1;
  }
}

fizzbuzz();

// 4. Prime Check
// write a function that returns a boolean based on if the provided argument
// is a prime number or not
// assumption: non-negative input
function isPrime(num) {
  if ([0, 1].includes(num) || (num > 2 && num % 2 === 0)) {
    return false;
  }

  let factors = [1, num];
  let factor = 2;

  while (factors.length == 2 && factor < num) {
    if (num % factor === 0) {
      factors.push(factor);
    }
    factor += 1;
  }

  return factors.length > 2 ? false : true;
}

isPrime(1);   // false
isPrime(2);   // true
isPrime(3);   // true
isPrime(43);  // true
isPrime(55);  // false
isPrime(0);   // false

// 5. GCD
// Write a function to calc the largest common divisor of 2 integers
// integer inputs are positive
function findFactors(number) {
  let factors = [1, number];
  let potentialFactor = 2;

  while (potentialFactor < number) {
    if (number % potentialFactor === 0){
      factors.push(potentialFactor);
    }
    potentialFactor += 1;
  }

  return factors;
}

function gcd(intOne, intTwo) {
  let factorsOne = findFactors(intOne);
  let factorsTwo = findFactors(intTwo);

  let likeFactors = factorsOne.filter(factor => factorsTwo.includes(factor));
  return Math.max(...likeFactors);
}

gcd(12, 4);   // 4
gcd(15, 10);  // 5
gcd(9, 2);    // 1

// update the function to accept an array of 2 or more numbers
// assumption: arr will contain at least 2 elements
function gcdMany(arr) {
  let factorsOne = findFactors(arr[0]);
  let factorsTwo = findFactors(arr[1]);
  let index = 2;

  let likeFactors = factorsOne.filter(factor => factorsTwo.includes(factor));
  
  while ((arr.length - 1) >= index) {
    let factors = findFactors(arr[index]);
    likeFactors = likeFactors.filter(factor => factors.includes(factor));
    index += 1;
  }
  return Math.max(...likeFactors);
}

gcdMany([12, 4, 8]);   // 4
gcdMany([16, 24, 32]); // 8
gcdMany([12, 6]);      // 6

// 6. GoldBach Numbers
// write a function that logs every pair of prime numbers that sum to the
// number supplied as an argumnet
// other requirements:
//  > log all pairs with the smallest numbe first
//  > if the argumnet is odd or less than 4 log null

// approach:
// > immediately return null if the passed in argument is less
//    than 4 or if it has a remainder when divided by 2 (which
//     proves it's an odd number)
// > 2 is the smallest prime number, so declare and initialize
//     a local variable to 2
// > start a loop construct and check that the local variable previously
//    initialized is <= half the size of the passed in argument
//     > b/c finding pairs that sum to the passed in argument,
//        only need to increment up to half of the passed in argument
//     > b/c this will be in an else branch and we already captured
//        logic for what to do when evaluating an odd sum, there is an
//        integer halfway point
// > in the loop declare another local variable that will sum with the other
//      local variable to the value of the argument passed into the function
// > check if both of the local variables are prime numbers using previously
//     defined isPrime() function
//     > if they are, then log their values
// > increment one of the local variables by 1 (the local variable that is
//      used to derive the other local variable's value through subtraction
//      needs to be incremented)
function checkGoldbach(expectedSum) {
  if (expectedSum < 4 || expectedSum % 2 !== 0) {
    console.log(null);
  } else {
    let num = 2;

    while (num < (expectedSum / 2 + 1)) {
      let addend = expectedSum - num;
      
      if (isPrime(num) && isPrime(addend)) {
        console.log(String(num) + ' ' + String(addend));
      }

      num += 1;
    }
  }
}

checkGoldbach(4);
// 2 2

checkGoldbach(100);
// 3 97
// 11 89
// 17 83
// 29 71
// 41 59
// 47 53


// 7. Convert strings to integers
// requirements:
// > can assume only numeric input
// > can assume not decimlals
// > don't need to worry about leading + / - sign
//     <=> so only positive strings in scope

// approach for finidng multiplier:
  // if length is 1, then multiplier is 1
  // if length is 2, then multiplier is 10
  // if length is 3, then multiplier is 100
  // if length is 4, then multiplier is 1000
  // if length is n, then multiplier is 10^(n - 1)
function stringToInteger(string) {
  const STRING_TO_NUM = {
    '0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5,
    '6': 6, '7': 7, '8': 8, '9': 9
  };
  
  let total = 0;
  let exponent = string.length - 1;

  for (let index = 0; index < string.length; index += 1) {
    let multiplier = Math.pow(10, exponent);

    total += STRING_TO_NUM[string[index]] * multiplier;
    exponent -= 1;
  }
  
  return total;
}

stringToInteger('4321');      // 4321
stringToInteger('570');       // 570

// 8. Convert A String to A Signed Number
function stringToSignedInteger(string) {
  let sign = string[0];

  if (sign === '+') {
    return stringToInteger(string.slice(1, string.length));
  } else if (sign === '-') {
    return -1 * stringToInteger(string.slice(1, string.length));
  } else {
    return stringToInteger(string);
  }

}

stringToSignedInteger('4321');      // 4321
stringToSignedInteger('-570');      // -570
stringToSignedInteger('+100');      // 100

// 9. Convert a Number to a String
// can assume a positive integer or 0 as an intput
function reverse(string) {
  return string.split('').reverse().join('');
}

function integerToString(integer) {
  const NUM_TO_STRING = {
    0: '0', 1: '1', 2: '2', 3: '3', 4: '4', 5: '5',
    6: '6', 7: '7', 8: '8', 9: '9'
  };

  let numberString = '';

  do {
    let remainder = integer % 10;
    integer = Math.floor(integer / 10);

    numberString += NUM_TO_STRING[remainder];
  } while (integer > 0);

  return reverse(numberString);
}

integerToString(4321);      // "4321"
integerToString(0);         // "0"
integerToString(5000);      // "5000"

// 10. Convert a Signed Number to a String
function signedIntegerToString(num) {
  if (num > 0) {
    return '+' + integerToString(num);
  } else if (num < 0) { 
    return '-' + integerToString(-num);
  } else {
    return integerToString(num);
  }

}

signedIntegerToString(4321);      // "+4321"
signedIntegerToString(-123);      // "-123"
signedIntegerToString(0);         // "0"

// 11. Leap Year
// determine if the numerical year value corresponds
// with a leap year or not & return a boolean
function isLeapYear(year) {
  if (year % 400 === 0) {
    return true;
  } else if (year % 100 === 0) {
    return false;
  } else {
    return year % 4 === 0;
  }
}

isLeapYear(2016);      // true
isLeapYear(2015);      // false
isLeapYear(2100);      // false
isLeapYear(2400);      // true
isLeapYear(1752);      // true
isLeapYear(1700);      // false

// 12. Sum of multiples
// write a function that calculates the total of all
// numbers between 1 and the passed in argument that
// are multiples of 3 or 5
function multisum(number) {
  let total = 0;

  for (let num = 0; num <= number; num += 1) {
    if (num % 3 === 0 || num % 5 === 0) {
      total += num;
    }
  }

  return total;
}

multisum(3);       // 3
multisum(5);       // 8
multisum(1000);    // 234168

// 13. Fibonacci Index
// write a function that returns the index location of
// the place in the fibonacci sequence that has the
// first number with the number of digits passed into
// the function as an argument
function findFibonacciIndexByLength(digits) {
  let num1 = 1;
  let num2 = 1;
  let count = 2;
  let fibonacci;

  do {
    fibonacci = num1 + num2;
    count += 1;
    num1 = num2;
    num2 = fibonacci;

  } while (String(fibonacci).length < digits);

  return count;
}

findFibonacciIndexByLength(2) === 7;    // 1 1 2 3 5 8 13
findFibonacciIndexByLength(3) === 12;   // 1 1 2 3 5 8 13 21 34 55 89 144

// 14. What Century Is It
// write a function that takes a number & returns the century in string format
function century(year) {
  const SUFFIX = { 
    '1': 'st', '2': 'nd', '3': 'rd', '4': 'th',
    '5': 'th', '6': 'th', '7': 'th', '8': 'th',
    '9': 'th', '0': 'th',
  };

  let century = String(Math.ceil(year / 100));
  let lastTwoDigits = century.split('').slice(century.length - 2, century.length).join('');

  if (["11", "12", "13"].includes(lastTwoDigits)) {
    century += 'th';
  } else {
    century += SUFFIX[century[century.length - 1]];
  }

  return century;
}

century(2000);        // "20th"
century(2001);        // "21st"
century(1965);        // "20th"
century(256);         // "3rd"
century(5);           // "1st"
century(10103);       // "102nd"
century(1052);        // "11th"
century(1127);        // "12th"
century(11201);       // "113th"

// 15. Right Triangles
// write a function that takes an integer argument repesenting
// the length of the sides of a right triangle and writes to the
// console stars forming the right triangle
// can assume that input is >= 1
function triangle(digits) {
  let numSpaces = digits - 1;
  let numStars = 1;

  while (numSpaces >= 0) {
    let row = ' '.repeat(numSpaces) + '*'.repeat(numStars);
    console.log(row);
    numSpaces -= 1;
    numStars += 1;
  }
}

triangle(5);
//    *
//   **
//  ***
// ****
//*****

triangle(9);
//        *
//       **
//      ***
//     ****
//    *****
//   ******
//  *******
// ********
//*********

// 16. Reverse A Number
// drop any leading zeros
function reverseNumber(num) {
  let reversed = '';
  let strNum = String(num);

  for (let idx = strNum.length - 1; idx >= 0; idx -= 1) {
    reversed += strNum[idx];
  }

  return Number(reversed);
}

reverseNumber(12345);    // 54321
reverseNumber(12000);    // 21
reverseNumber(1);        // 1

// 17. Angles to Degrees, Minutes, & Seconds
function addLeadingZero(number) {
  return (number < 10 ? "0" + String(number) : String(number));
}

function findSmallerUnits(unit, strDecimal, roundFlag) {
  let num = Number("." + strDecimal) * 60;
  if (roundFlag) {
    num = Math.floor(num);
  }

  num = addLeadingZero(num);
  return num + unit;
}

function dms(angle) {
  let strAngle = String(angle);

  if (!strAngle.includes(".")) {
    return strAngle + "°00'" + '00"';
  }

  let degs = strAngle.split('.')[0] + "°";  
  let mins = findSmallerUnits('', strAngle.split('.')[1], false);

  if (!mins.includes(".")) {
    return degs + mins + "'" + '00"';
  }

  let secs = mins.split('.')[1];
  mins = mins.split('.')[0] + "'";
  secs = findSmallerUnits('"', secs, true);

  return degs + mins + secs;
}
dms(30);           // 30°00'00"
dms(76.73);        // 76°43'48"
dms(254.6);        // 254°35'59"
dms(93.034773);    // 93°02'05"
dms(0);            // 0°00'00"
dms(360);          // 360°00'00" or 0°00'00"

// 18. write a function that takes a positive integer and returns the
//  sum of its digits via a chain of method calls
function sum(num) {
  let nums = String(num).split('');
  return nums.reduce((total, strNum) => total + Number(strNum));
}
sum(23);           // 5
sum(496);          // 19
sum(123456789);    // 45

// 19. convert word numbers in a string to their digit values
// > input: string word numbers range from 0 to 9 to match phone # digits
// > words are separated by single spaces
function wordToDigit(string) {
  let wordsAsDigits = {'zero': '0', 'one': '1',
    'two': '2', 'three': '3', 'four': '4',
    'five': '5', 'six': '6', 'seven': '7',
    'eight': '8', 'nine': '9',
  };

  return string.split(' ').map(word => {
    let wordLetters = word.match(/[A-Z]/gi).join('');
    if (Object.keys(wordsAsDigits).includes(wordLetters)) {
      let regex = new RegExp(word);
      return word.replace(regex, wordsAsDigits[wordLetters]);
    } else {
      return word;
    }
  }).join(' ');
}
wordToDigit('Please call me at five five five one two three four. Thanks.');
// "Please call me at 5 5 5 1 2 3 4. Thanks."

wordToDigit('The weight is done.'); // "The weight is done."

// 20. rotate last nth digit to the end of a number
function rotateRightmostDigits(num, n) {
  let str = String(num);
  let indices = [...Array(str.length).keys()];
  let idxOfCharToMove = str.length - n;
  let rotated = '';

  indices.forEach(index => {
    if (index !== idxOfCharToMove) {
      rotated += str[index];
    }
  });

  return Number(rotated + str[idxOfCharToMove]);
}
rotateRightmostDigits(735291, 1);      // 735291
rotateRightmostDigits(735291, 2);      // 735219
rotateRightmostDigits(735291, 3);      // 735912
rotateRightmostDigits(735291, 4);      // 732915
rotateRightmostDigits(735291, 5);      // 752913
rotateRightmostDigits(735291, 6);      // 352917


// 21. find the % of occurrences of different types of
//  letters in a given string
function letterPercentages(string) {
  let nChars = string.length;
  let pcts = [string.match(/[a-z]/g).length,
              string.match(/[A-Z]/g).length,
              string.match(/[^a-zA-Z]/g).length];
  
  pcts = pcts.map(num => prepPct(num / nChars));

  return {lowercase: pcts[0],
          uppercase: pcts[1],
          neither: pcts[2]};
}

function prepPct(num) {
  let strPct = String(num * 100);
  let decimalIdx = strPct.indexOf(".");
  let numDecimals = strPct.slice(decimalIdx).length;
  
  if (decimalIdx === -1 ) {
    strPct += ".00";
  } else if (numDecimals > 3) {
    let firstPart = strPct.slice(0, decimalIdx);
    let secondPart = strPct(decimalIdx, decimalIdx + 3);

    if (Number(strPct[decimalIdx + 4]) >= 5) {
      let roundUpValue = Number(secondPart[decimalIdx + 3]) + 1;
      secondPart[decimalIdx + 3] = String(roundUpValue);
    }

    strPct = firstPart + secondPart;

  } else if (numDecimals < 3) {
    let firstPart = strPct.slice(0, decimalIdx);
    let decimals = strPct.slice(decimalIdx);

    switch (decimals.length) {
      case 1:
        decimals += "00";
        break;
      case 2:
        decimals += "0";
        break;
    }
    strPct = firstPart + decimals;
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

console.log(letterPercentages('aBC'));
// { lowercase: "33.33", uppercase: "66.67", neither: "0.00" }

// 22. max rotate the digits in a number
// > Take the number 735291 & rotate it by one digit to the left, getting 352917
// > Next, keep the first digit fixed in place & rotate the remaining digits to get 329175
// > Keep the first two digits fixed in place and rotate again to get 321759
// > Keep the first three digits fixed in place and rotate again to get 321597
// > Finally, keep the first four digits fixed in place and rotate the final two digits to get 321579
// > The resulting number is called the maximum rotation of the original number
function maxRotation(num) {
  for (let x = String(num).length; x > 1; x -= 1) {
    num = rotateRightmostDigits(num, x);
  }

  return num;
}

maxRotation(735291);          // 321579
maxRotation(3);               // 3
maxRotation(35);              // 53
maxRotation(105);             // 15 -- the leading zero gets dropped
maxRotation(8703529146);      // 7321609845

// 23. triangle type
// > valid triangles must have the shorter 2 sides sum to a value
//     that exceeds the largest side
// > if all lengths are equal then it's equilateral
// > all lengths must exceed 0
// > 2 equivalent sides is isosceles
// > all different sides is scalene
function triangleType(...args) {
  if (invalidLengths(args)) {
    return "invalid";
  } else if (equilateral(args)) {
    return "equilateral";
  } else if (isosceles(args)) {
    return "isosceles";
  } else {
    return "scalene";
  }
}

function invalidLengths(lengths) {
  let positives = lengths.filter(positives);

  let max = Math.max(...lengths);
  let mins = lengths.filter((length, idx, arr) =>
    idx !== arr.indexOf(max));

  return max > mins[0] + mins[1] || positives.length === 0;
}

function positives(number) {
  return number > 0;
}

function equilateral(lengths) {
  return lengths[0] === lengths[1] &&
         lengths[1] === lengths[2];
}

function isosceles(lengths) {
  return lengths[0] === lengths[1] ||
         lengths[1] === lengths[2];
}

triangleType(3, 3, 3);        // "equilateral"
triangleType(3, 3, 1.5);      // "isosceles"
triangleType(3, 4, 5);        // "scalene"
triangleType(0, 3, 3);        // "invalid"
triangleType(3, 1, 1);        // "invalid"

// 24. triangle angle classification
function triAngleType(...args) {
  if (invalidAngles(args)) {
    return "invalid";
  } else if (args.includes(90)) {
    return "right";
  } else if (args.filter(lessThan90).length === 3) {
    return "acute";
  } else {
    return "obtuse";
  }
}

function lessThan90(num) {
  return num < 90;
}

function invalidAngles(angles) {
  return angles.filter(positives).length < 3 ||
    angles.reduce((sum, value) =>  sum + value) !== 180;
}

triAngleType(60, 70, 50);       // "acute"
triAngleType(30, 90, 60);       // "right"
triAngleType(120, 50, 10);      // "obtuse"
triAngleType(0, 90, 90);        // "invalid"
triAngleType(50, 50, 50);       // "invalid"

// 25. calculate the difference between the swuare of the sum of the first
// n positive integers and the sum of the squares of the first n positive
// integers
// > if n (provided argument) is 3:
//     (1 + 2 + 3)**2 - (1**2 + 2**2 + 3**2)
function sumSquareDifference(n) {
  let nums = [...Array(n + 1).keys()].slice(1);
  let squareOfSums = square(nums.reduce(add));
  let sumOfSquares = nums.map(square).reduce(add);

  return squareOfSums - sumOfSquares;
}

function add(num1, num2) {
  return num1 + num2;
}

function square(num) {
  return num ** 2;
}

sumSquareDifference(3);      // 22 
sumSquareDifference(10);     // 2640
sumSquareDifference(1);      // 0
sumSquareDifference(100);    // 25164150

// 26. find the next featured number
// featured number = odd number that is a multiple of 7, with all of its digits
//     occurring exactly once each
// Ex: 49 is a featured number
//     98 is not (it is not odd), 97 is not (it is not a multiple of 7), and
//        133 is not (the digit 3 appears twice).
// > return a string msg if no next feature number available
//     >> The largest possible featured number is 9876543201.
// smallest possible featured number is 7
function featured(num) {
  let startMultiple = Math.ceil(num / 7) * 7;

  for (let feature = startMultiple; feature <= 9876543201; feature += 7) {
    if (isOdd(feature) && uniqueDigits(feature) && feature > num) {
      return feature;
    }
  }

  return "There is no possible number that fulfills those requirements.";
}

function uniqueDigits(feature) {
  let digits = String(feature);

  return digits.split('').every((char, idx, chars) =>
    chars.indexOf(char) === idx &&
    chars.lastIndexOf(char) === idx);
}

function isOdd(num) {
  return num % 2 !== 0;
}

featured(12);           // 21
featured(20);           // 21
featured(21);           // 35
featured(997);          // 1029
featured(1029);         // 1043
featured(999999);       // 1023547
featured(999999987);    // 1023456987
featured(9876543186);   // 9876543201
featured(9876543200);   // 9876543201
featured(9876543201);   // "There is no possible number that fulfills those requirements."







