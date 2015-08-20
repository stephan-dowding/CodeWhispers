challengeUtils = require './challengeUtils'

challenge = ->
  startX = Math.floor(Math.random() * 20) + 10
  startY = Math.floor(Math.random() * 20) + 10
  instructions = challengeUtils.getInstructions(Math.floor(Math.random() * 10) + 10)
  endPosition = challengeUtils.calculateEndPosition(instructions, [startX, startY])

  question:
    startX: startX
    startY: startY
    instructions: instructions.join ''
  answer:
    endX: endPosition[0]
    endY: endPosition[1]

exports.challenge = challenge
