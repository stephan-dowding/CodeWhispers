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

calculateTreasureCoordinate = (instructions, shouldFindTreasure, startingCoordinate) ->
  if(shouldFindTreasure)
    treasureAtMove = Math.floor(Math.random() * instructions.length + 1)
    return calculateEndPosition(instructions.slice(0, treasureAtMove), startingCoordinate)
  else
    treasureX = Math.floor(Math.random() * 20) + 50
    treasureY = Math.floor(Math.random() * 20) + 50
    return [treasureX, treasureY]

exports.calculateEndPosition = calculateEndPosition
exports.getInstructions = getInstructions
exports.calculateTreasureCoordinate = calculateTreasureCoordinate
