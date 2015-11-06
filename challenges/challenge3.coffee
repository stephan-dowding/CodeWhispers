challengeUtils = require './challengeUtils'

exports.challenge = ->
  shouldFindTreasure = Math.floor(Math.random() * 2) == 1
  getChallenge(shouldFindTreasure)

getChallenge = (shouldFindTreasure) ->

  startX = Math.floor(Math.random() * 20) + 10
  startY = Math.floor(Math.random() * 20) + 10

  instructions = challengeUtils.getInstructions(Math.floor(Math.random() * 10) + 10)

  endPosition = challengeUtils.calculateEndPosition(instructions, [startX, startY])
  treasureCoordinate = challengeUtils.calculateItemCoordinate(instructions, shouldFindTreasure, [startX, startY])

  question:
    startX: startX
    startY: startY
    treasureX: treasureCoordinate[0]
    treasureY: treasureCoordinate[1]
    instructions: instructions.join ''
  answer:
    endX: endPosition[0]
    endY: endPosition[1]
    treasureFound: shouldFindTreasure

exports.getChallenge = getChallenge
