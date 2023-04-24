document.addEventListener('DOMContentLoaded', function() {
  let form = document.querySelector("form");
  form.addEventListener('submit', event => {
    const findVal = (id) => document.getElementById(id).value;
    event.preventDefault();
    let firstNum = parseInt(findVal('first-number'), 10);
    let secondNum = parseInt(findVal('second-number'), 10);
    let operator = document.getElementById('operator').value;
    let result;
    
    switch (operator) {
      case '+':
        result = firstNum + secondNum;
        break;
      case '-':
        result = firstNum - secondNum;
        break;
      case '/':
        result = firstNum / secondNum;
        break;
      case '*':
        result = firstNum * secondNum;
        break;
    }

     document.querySelector('#result').textContent = String(result);
  });
});
