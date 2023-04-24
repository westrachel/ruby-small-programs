function nodeSwap(id1, id2) {
  let el1 = document.getElementById(id1);
  let el2 = document.getElementById(id2);

  if (isNull(el1, el2) || isChild(id1, el2) || isChild(id2, el1)) {
    return undefined;
  } else {
    
    let p1 = el1.parentNode;
    let sib1 = el1.nextSibling;
    let p2 = el2.parentNode;
    let sib2 = el2.nextSibling;
    
    p2.insertBefore(el1, sib2);
    p1.replaceChild(el2, sib1);
    return true;
  }
}

function isChild(id, el) {
  let children = el.childNodes;
  
  for (let i = 0; i < children.length; i += 1) {
    if (children[i].id === id) {
      return true;
    }
  }
}

function isNull(...args) {
  return args.some(el => el === null);
}

// at least one of the id attributes doesn't exist
nodeSwap(1, 20);
// undefined

// at least one of the nodes is a "child" of the other
nodeSwap(1, 4);
// undefined
nodeSwap(9, 3);
// undefined

// valid swaps:
nodeSwap(3, 1); // true
nodeSwap(7, 9); // true
// order of divs: 3, 9, 8, 7, 2, 1, 4, 5, 6