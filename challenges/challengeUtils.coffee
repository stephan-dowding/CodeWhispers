calculateEndPosition = (instructions, startingCoordinate) ->
  instructions.reduce ((x,y) ->
    if (y == 'L') then [x[0], x[1] + 1]
    else if (y == 'R') then [x[0], x[1] - 1]
    else if (y == 'F') then [x[0] + 1, x[1]]
    else [x[0] - 1, x[1]]), startingCoordinate

getInstructions = (numberOfMoves) ->
  [1..numberOfMoves].map (num) ->
    number = Math.floor(Math.random() * 4)
    if number == 0 then 'L'
    else if number == 1 then 'R'
    else if number == 2 then 'F'
    else if number == 3 then 'B'

calculateItemCoordinate = (instructions, shouldFindItem, startingCoordinate) ->
  if(shouldFindItem)
    itemAtMove = Math.floor(Math.random() * instructions.length + 1)
    return calculateEndPosition(instructions.slice(0, itemAtMove), startingCoordinate)
  else
    itemX = Math.floor(Math.random() * 20) + 50
    itemY = Math.floor(Math.random() * 20) + 50
    return [itemX, itemY]

exports.calculateEndPosition = calculateEndPosition
exports.getInstructions = getInstructions
exports.calculateItemCoordinate = calculateItemCoordinate
