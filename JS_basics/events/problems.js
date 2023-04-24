// 1) implement function that:
//   > accepts 'n' callbacks
//   > calls each callback at some random point in time w/in 2 * n # of seconds
//   > log the elapsed time every second 1, 2, ... , 2 * n

function randomizer(...cbs) {
  if (cbs.length === 0) {
    return;
  }
  
  const maxTime = 2 * cbs.length;
  let timeElapsed = 0;
  
  const logger = setInterval(() => {
    timeElapsed += 1;
    console.log(timeElapsed);
    
    if (timeElapsed >= maxTime) {
      clearInterval(logger);
    }
  }, 1000);

  cbs.forEach(callback => {
    setTimeout(callback, randomDelay(maxTime));
  });
}

function randomDelay(maxDelay) {
  return Math.ceil(Math.random() * maxDelay) * 1000;
}

function callback1() {
  console.log('callback1');
}

function callback2() {
  console.log('callback2');
}

function callback3() {
  console.log('callback3');
}

randomizer(callback1, callback2, callback3);

// 2) refactor the given event listeners to maintain their behavior while
// removing the event.stopPropagation line
// given event listeners:
document.querySelector('html').addEventListener('click', () => {
  document.querySelector('#container').style = 'display: none';
});

document.querySelector('#container').addEventListener('click', event => {
  event.stopPropagation();
});

// notes:
// > if a nested element that's located w/in the element w/ the id 'container' or
//   the element that has the 'container' id is clicked then once the event reaches
//   the element w/ the id 'container' it's stopped from further propagating
//     <=> so, if the container element or one of its children is clicked
//     then the event listener on the html element will never be fired, because the
//     listener on the element with 'container' id is processed on the bubbling phase
//     and prevents propagation from continuing onto the event listener on <html> that
//     would assign/reassign the style attribute of the element with the 'container' id
//     and would essentially hide the container
// > if user clicks on any element outside of the container id, then the container element
//    will be hidden b/c the listener on the container element that stops propagation won't
//    be evaluated

// refactored:
// check if element user clicked on is the element with 'container' id or is one of the
//   children of the element w/ the 'container' id and if it's not then update the style
//   attribute on the element w/ the 'container' id to hide the element
document.querySelector('html').addEventListener('click', event => {
  let container = document.querySelector('#container');
  
  if (!container.contains(event.target)) {
    container.style = 'display: none';
  }
});

// 3) implement a function that:
//   > bolds an element and accepts a 2nd optional argument that lets the user
//     do something w/ the element specified as the 1st argument
// ex of how function should work:
let sectionElement = document.querySelector('section');
makeBold(sectionElement, function(elem) {
  elem.classList.add('highlight');
});

sectionElement.classList.contains('highlight'); // true
sectionElement.style.fontWeight;  // "bold"

// definition:
function makeBold(el, callback) {
  el.style.fontWeight = 'bold';
  if (callback && typeof callback === 'function') {
    callback(el); 
  }
}

// 4) why does clicking the image still bring the user to another web page
// when there's an event.stopPropagation?
document.querySelector('img').addEventListener('click', event => {
  event.stopPropagation();
}, false);

// given html:
//<a href="https://www.thisisnotanactualwebsite.com">
//  Home
//  <img src="thisisamadeupsrcattributeforanonexistentphoto"/>
//</a>

// notes:
// > event.stopPropagation() prevents the code from propagating further
// > when user clicks on the image that's part of the anchor element in the html, 
//    since the 3rd optional argument is set to false, the event listener will be
//    evaluated during the bubbling phase and when it's evalauted it will stop the
//    event from further propagating on the bubbling phase and visiting any parent
//    elements that are outside/parents of the anchor element; thus, event listeners
//    on any parents won't be evaluated
// > the default behavior occurs after propagation and it's not prevented/stopped
//    by event.stopPropagation
// > so, the web page will still open/follow through to the new page, because that's
//   the default behavior when the link / anchor element is clicked
// > if wanted to prevent the web page opening another web page, then should replace
//     event.Propagation with event.preventDefault() in the given event listener 

// 5) implement contextmenu event handlers that:
// > display single alert that specifies whether right clicked on the main
//     area or the sub area
// > so, if right click on the sub area, then an alert for main should not appear

// given html:
// <main>
//   Main Area
//   <section id="sub">
//    Sub Area
//   </section>
// </main>

// event handlers:
let main = document.querySelector('main');
let sub = document.querySelector('section');

main.addEventListener('contextmenu', event => {
  event.preventDefault();
  alert('Main');
});

sub.addEventListener('contextmenu', event => {
  event.preventDefault();
  event.stopPropagation();
  alert('Sub');
});

// 6) implement JS that:
// i. When the user clicks on a navigation link (Articles 1-4), the 
//   browser scrolls to that article in the <main> element and adds
//   the highlight class to it. If another element already has the highlight class,
//   the browser removes the class from that element.
// ii. When the user clicks on an article element or any of its child elements,
//    the browser adds the highlight class to it. If another element already has
//    the highlight class, the browser removes the class from that element.
// iii. When the user clicks anywhere else on the page, the browser adds the
// highlight class to the main element. If another element already has the highlight
//    class, the browser removes the class from that element.

document.addEventListener('click', event => {
  removeExistingHighlight();
  
  let elToHighlight;
  let elClicked = event.target;
  let tag = elClicked.tagName;
  console.log('element' + elClicked);
  console.log('id' + elClicked.id);
  
  if (tag === 'A') {
    let id = elClicked.href.match('#article-[0-9]+')[0];
    let article = document.querySelector(id);
    elToHighlight = article;
  } else if (tag === 'ARTICLE') {
    elToHighlight = elClicked;
  } else if (elClicked.parentNode.tagName === 'ARTICLE') {
    elToHighlight = elClicked.parentNode;
  } else {
    elToHighlight = document.querySelector('main');
  }

  addHighlight(elToHighlight);
});

function addHighlight(element) {
  element.classList.add('highlight');
}

function removeExistingHighlight() {
  let removals = document.getElementsByClassName('highlight');
  
  Array.prototype.slice.call(removals).forEach(el => {
    el.classList.remove('highlight');
  });
}

// 7) implement delegateEvent function that:
// > accepts 4 arguments: parentElement, selector (to find inner elements of the parent),
//     the eventType (for the listener), and the callback 
// > returns a boolean - 
//    > true if it could added the event listener undefined otherwise

// given html:
//<!doctype html>
//<html lang="en-US">
//  <head>
//    <meta charset="utf-8">
//    <title>Event Delegation Function</title>
//  </head>
//  <body>
//    <main>
//      <section>
//        <h1>Header</h1>
//        <p>Content</p>
//      </section>
//      <aside>
//        <h2>Sub Side Notes</h2>
//        <p>Note 1</p>
//        <p>Note 2</p>
//      </aside>
//    </main>
//    <nav>
//      <p>Side Note</p>
//    </nav>
//  </body>
//</html>

// sample elements + callback for testing:
const element1 = document.querySelector('table');
const element2 = document.querySelector('main');

const callback = ({target, currentTarget}) => {
  alert(`Target: ${target.tagName}\nCurrent Target: ${currentTarget.tagName}`);
};

function delegateEvent(parent, selector, eventType, cb) {
  if (parent && parent instanceof Element) {
    return !parent.addEventListener(eventType, event => {
      let kids = parent.querySelectorAll(selector);
      let targets = Array.prototype.slice.call(kids);
      if (targets.includes(event.target)) {
        cb(event);
      }
    });
  }
}

// test cases:
delegateEvent(element1, 'p', 'click', callback); // undefined
delegateEvent(element2, 'h1', 'click', callback); // true
// <=> click event listener is added to element3, and if click the
// h1 element that contains the text "Header" the callback function
// should trigger and display an alert message, but if anywhere else is
//  clicked, the callback function doesn't trigger
delegateEvent(element2, 'aside p', 'click', callback); // true
// <=> adds click event listener to element3
// if click p element that's descendent of aside w/in <main>
// cb function should send alert, whereas if click anywhere else
// the cb function shouldn't be triggered


// 8) given id of element, create nested array that outlines
// all the elements and their siblings in separate subarrays
<html>

<head>
  <title>Tracing the DOM Tree</title>
</head>

<body>
  <article id="1">1
    <header id="2">2
      <span id="3">3
        <a href="#" id="4">4</a>
      </span>
    </header>
    <main id="5">5
      <section id="6">6
        <p id="7">7
          <span id="8">8
            <strong id="9">9
              <a href="#" id="10">10</a>
            </strong>
          </span>
        </p>
      </section>
      <section id="11">11
        <p id="12">12
          <span id="13">13
            <strong id="14">14
              <a href="#" id="15">15</a>
            </strong>
          </span>
        </p>
        <p id="16">16
          <span id="17">17
            <strong id="18">18
              <a href="#" id="19">19</a>
            </strong>
          </span>
          <span id="20">20
            <strong id="21">21
              <a href="#" id="22">22</a>
            </strong>
          </span>
        </p>
      </section>
    </main>
    <footer id="23">23
      <p id="24">24</p>
    </footer>
  </article>
</body>
</html>

function domTreeTracer(id) {
  let tree = [];
  let currEl = document.getElementById(id);
  tree.push(findSibs(currEl));
  currEl = currEl.parentNode;
  
  while (currEl.tagName !== 'BODY') {
    tree.push(findSibs(currEl));
    currEl = currEl.parentNode;
  }
  
  return tree;
}

function findSibs(el) {
  let currElId = el.id;
  let parent = el.parentNode;
  let sibsArr = [el.tagName];
  let sibs = parent.children;
  
  if (sibs && parent.tagName !== 'BODY') {
    Array.prototype.slice.call(sibs).forEach(el => {
      if (el.id !== currElId) {
        sibsArr.push(el.tagName);
      }
    });
  }
  
  return sibsArr;
}

// test cases:
domTreeTracer(1);   // [["ARTICLE"]]
domTreeTracer(2);   // [["HEADER", "MAIN", "FOOTER"], ["ARTICLE"]]
domTreeTracer(22);  // [["A"], ["STRONG"], ["SPAN", "SPAN"], ["P", "P"], 
            //          ["SECTION", "SECTION"], ["HEADER", "MAIN", "FOOTER"], ["ARTICLE"]]

