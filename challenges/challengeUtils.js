exports.calculateEndPosition = function(instructions, startingCoordinate) {
  let path = exports.calculatePath(instructions, startingCoordinate)
  return path[path.length - 1];
};

exports.getInstructions = function(numberOfMoves) {
  return Array(numberOfMoves).fill()
  .map(() => {
    let number = Math.floor(Math.random() * 4);
    if (number === 0) return 'L';
    if (number === 1) return 'R';
    if (number === 2) return 'F';
    return 'B';
  })
};

exports.calculateItemCoordinate = function(instructions, shouldFindItem, startingCoordinate) {
  if (shouldFindItem) {
    let itemAtMove = Math.floor(Math.random() * instructions.length + 1);
    return exports.calculateEndPosition(instructions.slice(0, itemAtMove), startingCoordinate);
  }
  let itemX = Math.floor(Math.random() * 20) + 50;
  let itemY = Math.floor(Math.random() * 20) + 50;
  return [itemX, itemY];
};

exports.getFirstIndexOfCoordinate = function(searchCoordinate, instructions, startingCoordinate) {
  let route = exports.calculatePath(instructions, startingCoordinate);
  return route.reduce(function(searchIndex, pos, index) {
    if (!searchIndex && pos[0] === searchCoordinate[0] && pos[1] === searchCoordinate[1]) {
      searchIndex = index;
    }
    return searchIndex;
  }, undefined);
};

exports.calculatePath = function(instructions, startingCoordinate) {
  return instructions.reduce((function(path, instruction) {
    let prev = path[path.length - 1];
    if (instruction === 'L') path.push([prev[0], prev[1] + 1]);
    if (instruction === 'R') path.push([prev[0], prev[1] - 1]);
    if (instruction === 'F') path.push([prev[0] + 1, prev[1]]);
    if (instruction === 'B') path.push([prev[0] - 1, prev[1]]);
    return path;
  }), [startingCoordinate]);
};
