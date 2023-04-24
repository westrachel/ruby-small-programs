// 1. create a function that iterates from 1 to a number
// and logs each # after that specific # of seconds
// ex: for n = 1, only 1 should be logged after 1 second
function delayLog(n) {
  let nums = [...Array(n + 1).keys()].slice(1);
  nums.forEach(num => {
    setTimeout(() => {
      console.log(num);
    }, num * 1000);
  });
}

delayLog(10);

// 2. Label the sequence of execution
setTimeout(() => {          // 1
  console.log('Once');      // 5
}, 1000);                 

setTimeout(() => {          // 2
  console.log('upon');      // 7
}, 3000);                 

setTimeout(() => {          // 3
  console.log('a');         // 6
}, 2000);            

setTimeout(() => {          // 4
  console.log('time');      // 8
}, 4000);

// 3. Label the sequence in which q, d, n, z, s, f, an g are run
let g = function() {};
let n = function() {};
let f = function() {};
let z = function() {};
let s = function() {};
let d = function() {};
let q = function() {};

setTimeout(() => {
  setTimeout(() => {
    q();
  }, 15);             // ((15 + 10) / 1000) second delay

  d();                // 10 / 1000 second delay

  setTimeout(() => {
    n();
  }, 5);              // ((10 + 5) / 1000) second delay

  z();                // 10 / 1000 second delay
}, 10);

setTimeout(() => {
  s();
}, 20);              // 20 / 1000 second delay

setTimeout(() => {
  f();
});

g(); // (*)

// order:
// g, f, d, z, n, s, q

// 4. create a function that accepts a function + executes it after a specified
// period of time
function afterNSeconds(func, numSeconds) {
  setTimeout(func, 1000 * numSeconds);
}

// 5. create a function will log an incrementing number every second starting from 1
// and is cleared only when a specific stop function is called
let counter;

function startCounting() {
  let num = 0;
  counter = setInterval(() => {
    num += 1;
    console.log(num);
  }, 1000);
}

function stopCounting() {
  clearInterval(counter);
}

startCounting();
afterNSeconds(stopCounting, 10);