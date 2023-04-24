// create nested array showing the body element of children.html and all
// of its nested children

function nodesToArr() {
  const nodesArray = ['BODY', formatNodes(kidsArr(document.body))];
  let currParents = nodesArray[1];

  while (anyChildren(currParents)) {
    currParents = getNextGenParents(currParents);
  }

  getNextGenParents(currParents);

  return nodesArray;
}

function kidsArr(element) {
  return Array.prototype.slice.call(element.children);
}

function getNextGenParents(currParents) {
  let newParentNodes = [];
  currParents.forEach((parentNode, index, parentNodes) => {
    parentNodes[index] = appendKids(parentNode);
    if (parentNodes[index][1].length > 0) {
      newParentNodes = newParentNodes.concat(parentNodes[index][1]);
    }
  });

  return newParentNodes;
}

function anyChildren(parentNodes) {
  for (let i = 0; i < parentNodes.length; i += 1) {
    if (parentNodes[i][0].children.length > 0) {
      return true;
    }
  }

  return false;
}

function appendKids(parentNode) {
  const children = formatNodes(kidsArr(parentNode[0]));
  parentNode[0] = parentNode[0].tagName;
  parentNode.push(children);
  return parentNode;
}

function formatNodes(nodes) {
  return nodes.map(node => [node]);
}

nodesToArr();
//["BODY", [
//    ["HEADER", []],
//    ["MAIN", [
//      ["DIV", []],
//      ["DIV", []]]],
//    ["FOOTER",[]]]]