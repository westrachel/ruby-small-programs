import debounce from './debounce.js';

// set up base UI of app
const Autocomplete = {
  wrapInput: function() {
    let wrapper = document.createElement('div');
    wrapper.classList.add('autocomplete-wrapper');
    this.input.parentNode.appendChild(wrapper);
    wrapper.appendChild(this.input);
  },
  
  createUI: function() {
    let listUI = document.createElement('ul');
    listUI.classList.add('autocomplete-ui');
    this.input.parentNode.appendChild(listUI);
    this.listUI = listUI;
    
    let overlay = document.creatElement('div');
    overlay.classList.add('autocomplete-overlay');
    overlay.style.width = `${this.input.clientWidth}px`;

    this.input.parentNode.appendChild(overlay);
    this.overlay = overlay;
  },
  
  // add method to bind event listeners to UI elements after the UI is built
  bindEvents: function() {
    // add input event listener on the text input & set valueChanged method as the callback
    this.input.addEventListener('input', this.valueChanged);
    this.input.addEventListener('input', this.valueChanged.bind(this));
    this.input.addEventListener('keydown', this.handleKeydown.bind(this));
    this.input.addEventListener('mousedown', this.handleKeydown.bind(this));
  },

  handleMousedown: function(event) {
    let element = event.target;
    this.input.value = element.textContent;
    this.reset();
  },

  valueChanged: function() {
    let value = this.input.value;
    this.previousValue = value;
    
    // only want to retrieve matches if the text input is not empty
    if (value.length > 0) {
      this.fetchMatches(value, matches => {
        this.visible = true;  // use visible property on Autocomplete object to determine if overlay has any text
        this.matches = matches;   // matches to be array of data retrieved from server
        this.bestMatchIndex = 0;
        this.selectedIndex = null;
        this.draw();
      });
    } else {
      this.reset();
    }
  },

  fetchMatches: function(query, callback) {
    let request = new XMLHttpRequest();
    
    request.addEventListener('load', () => {
      callback(request.response);
    });

    // send XHR w/ our base URL cocnatenated w/ dynamic query string 
    request.open('GET', `${this.url}${encodeURIComponent(query)}`);
    request.responseType = 'json';
    request.send();
  },
  
  draw: function() {
    // remove any previously rendered listUI elements
    while (this.listUI.lastChild) {
      this.listUI.removeChild(this.listUI.lastChild);
    }
    
    // visible property flags if text input is empty or not
    if (!this.visible) {
      this.overlay.textContent = '';
      return;
    }

    // render in the input overlay the best match value from the matches array
    if (this.bestMatchIndex !== null && this.matches.length !== 0) {
      let selected = this.matches[this.bestMatchIndex];
      this.overlay.textContent = this.generateOverlayContent(this.input.value, selected);
    } else {
      this.overlay.textContent = '';
    }

    // repopulate listUI w/ the current set of matched countries that are received from the server
    this.matches.forEach((match, index) => {
      let li = document.createElement('li');
      li.classList.add('autocomplete-ui-choice');
      
      if (index === this.selectedIndex) {
        li.classList.add('selected');
        this.input.value = match.name;
      }
    
      li.textContent = match.name;
      this.listUI.appendChild(li);
    });
  },

  handleKeydown: function(event) {
    switch(event.key) {
      case 'ArrowDown':
        event.preventDefault();
        if (this.selectedIndex === null || this.selectedIndex === this.matches.length - 1) {
          this.selectedIndex = 0;
        } else {
          this.selectedIndex += 1;
        }
        this.bestMatchIndex = null;
        this.draw();
        break;
      case 'ArrowUp':
        event.preventDefault();
        if (this.selectedIndex === null || this.selectedIndex === 0) {
          this.selectedIndex = this.matches.length - 1;
        } else {
          this.selectedIndex -= 1;
        }
        this.bestMatchIndex = null;
        this.draw();
        break;
      case 'Enter':
        this.reset();
        break;
      case 'Escape':
        this.input.value = this.previousValue;
        this.reset();
        break;
      case 'Tab':
        if (this.bestMatchIndex !== null && this.matches.length !== 0) {
          this.input.value = this.matches[this.bestMatchIndex].name;
          event.preventDefault();
        }
        this.reset();
        break;
    }
  },

  reset: function() {
    this.visible = false;
    this.matches = [];
    this.bestMatchIndex = null;
    this.selectedIndex = null;
    this.previousValue = null;
    this.draw();
  },
  
  init: function() {
    // add 2 properties to Autocomplete object
    this.input = document.querySelector('input');
    this.url = '/countries?matching=';    // will use this to fetch the JSONdata
    
    this.listUI = null;
    this.overlay = null;
    this.wrapInput();   // wrap text input inside a div element w/ desired class
    this.createUI();    // create 2 DOM elements as siblings of the text input
                        //    i. a ul element w/ a class of autocomplete-ui
                       //  ii. another div w/ class of autocomplete-overlay to overlay ontop of text input
  
    this.valueChanged = debounce(this.valueChanged.bind(this), 300);
    this.bindEvents();
    this.reset();
  }
};

document.addEventListner('DOMContentLoaded', () => {
  // ensure DOM is ready before manipulate it
  Autocomplete.init();
})