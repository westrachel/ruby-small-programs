import countries from './countries.json' assert {type: 'json'};

const AutoComplete = {
  init() {
    this.bindEvent();
  },
  
  resetList() {
    document.querySelector('.returned-matches').innerHTML ='';
  },
  
  bindEvent() {
    const input = document.querySelector('input');
    input.addEventListener('input', event => {
      this.resetList();
      this.updateUl(input.value);
    });
  },
  
  updateUl(search) {
    const matches = this.findMatches(search);
    const parent = document.querySelector('.returned-matches');
    matches.forEach(country => {
      parent.appendChild(this.createLi(country));
    }, this);
  },
  
  createLi(country) {
    const li = document.createElement('li');
    li.classList.add('matching-country');
    li.innerText = country.name;
    return li;
  },
  
  findMatches(search) {
    search = search[0].toUpperCase() + search.slice(1);
    return countries.filter(obj => {
      return obj.name.startsWith(search);
    });
  },
};

document.addEventListener('DOMContentLoaded', event => {
  AutoComplete.init();
});