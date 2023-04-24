// 1. xOr
// write a function that returns true if exactly 1 argument is truthy
// and false otherwise
function isXor(argOne, argTwo) {
  let countTruthyValues = 0;
  let booleans = [Boolean(argOne), Boolean(argTwo)];

  for (let index = 0; index < 2; index += 1) {
    if (booleans[index] === true) {
      countTruthyValues += 1;
    }
  }

  return countTruthyValues === 1 ? true : false;
}

isXor(false, true);     // true
isXor(true, false);     // true
isXor(false, false);    // false
isXor(true, true);      // false


isXor(false, 3);        // true
isXor('a', undefined);  // true
isXor(null, '');        // false
isXor('2', 23);         // false

// refactored solution to condense
function isXor(argOne, argTwo) {
  return Boolean(argOne) !== Boolean(argTwo);
}
