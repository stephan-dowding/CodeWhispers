challengeUtils = require './challengeUtils'

challenge = ->
  startX = Math.floor(Math.random() * 20) + 10
  startY = Math.floor(Math.random() * 20) + 10
  instructions = getInstructions(Math.floor(Math.random() * 10) + 10)
  endPosition = challengeUtils.calculateEndPosition(instructions, [startX, startY])

  question:
    startX: startX
    startY: startY
    instructions: instructions.join ''
  answer:
    endX: endPosition[0]
    endY: endPosition[1]

getInstructions = (numberOfMoves) ->
  [1..numberOfMoves].map (num) ->
    number = Math.floor(Math.random() * 4)
    if number == 0 then 'L'
    else if number == 1 then 'R'
    else if number == 2 then 'F'
    else if number == 3 then 'B'

exports.challenge = challenge
