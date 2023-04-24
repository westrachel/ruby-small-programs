document.addEventListener('DOMContentLoaded', () => {
  let input = document.querySelector('#guess');
  let form = document.querySelector('form');
  let paragraph = document.querySelector('p');
  let link = document.querySelector('a');
  let answer;
  let numGuesses;

  function newGame() {
    answer = Math.floor(Math.random() * 100) + 1;
    numGuesses = 0;
    paragraph.textContent = 'Guess a number from 1 to 100';
  }

  function validGuess(guess) {
    let num = Number(guess);
    let btwn1and100 = num >= 1 & num <= 100;
    return guess.match(/^[0-9]{1,3}$/) & btwn1and100;
  }

  form.addEventListener('submit', event => {
    event.preventDefault();

    let guess = input.value;
    
    if (!validGuess(guess)) {
      let invalidMsg = "Your guess is invalid; Please guess only a whole number within [1,100].";
      paragraph.textContent = invalidMsg;
    } else {
      let message = "Your guess is ";
      numGuesses += 1;

      if (guess > answer) {
        message += "too high.";
      } else if (guess < answer) {
        message += "too low";
      } else {
        message += `correct! You guessed the number in ${numGuesses} attempt`;
        let ending = numGuesses === 1 ? "!" : "s.";
        message += ending;
      }

      paragraph.textContent = message;
    }
  });

  link.addEventListener('click', event => {
    event.preventDefault();
    newGame();
  });

  newGame();
});