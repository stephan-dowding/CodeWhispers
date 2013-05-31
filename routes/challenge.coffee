mongo = require 'mongodb'

connection = require './connection'

round = require './round'

exports.question = (req, res) ->

  connection.open (error, client) ->
    round.getRound client, res, (round) ->

      challenge = generateQandA(round)
      challenge.team = req.params['team']

      collection = new mongo.Collection client, 'challenge'
      collection.remove {team: challenge.team}, {safe:true}, (err, objects) ->
        if err
          client.close()
          res.send(500, err)
        else
          collection.save challenge, {safe:true}, (err, objects) ->
            client.close()
            if err
              res.send(500, err)
            else
              res.json challenge.question

exports.answer = (req, res) ->
  team = req.params['team']

  connection.open (error, client) ->
    round.getRound client, res, (round) ->

      collection = new mongo.Collection client, 'challenge'
      collection.findOne {team: team}, (err, doc) ->
        if err
          client.close()
          res.send(500, err)
        else
          console.log doc
          console.log req.body
          gotItRight = correct(req.body, doc.answer, round)
          setResult client, res, round, team, gotItRight, ->
            client.close()
            if gotItRight
              res.send(200, "OK")
            else
              res.send(418, "D'oh!")

setResult = (client, res, round, team, gotItRight, callback) ->
  collection = new mongo.Collection client, 'branches'
  collection.findOne {name: team}, (err, doc) ->
    if err
      client.close()
      res.send(500, err)
    else if doc
      doc[round] = gotItRight
      collection.save doc, {sfe:true}, (err, objects) ->
        if err
          client.close()
          res.send(500, err)
        else
          callback()
    else
      callback()

correct = (reqBody, answer, round) ->
  return checkEnd(reqBody, answer) if round == 0  || round == 1
  return checkEndCoordinate(reqBody, answer) if round == 2
  return checkEndCoordinateWithTreasureFound(reqBody, answer) if round ==3

checkEnd = (reqBody, answer) ->
  return reqBody['end'] == answer.end.toString()

checkEndCoordinate = (reqBody, answer) ->
  try
    return parseInt(reqBody['endX'], 10) == answer.endX and parseInt(reqBody['endY'], 10) == answer.endY
  catch e
    return false
  
  return reqBody['endX'] == answer.endX.toString() and reqBody['endY'] == answer.endY.toString()

checkEndCoordinateWithTreasureFound = (reqBody, answer) ->
  return checkEndCoordinate(reqBody, answer) and reqBody['treasureFound'] == answer.treasureFound.toString()

generateQandA = (round) ->
  return question0() if round == 0
  return question1() if round == 1
  return question2() if round == 2
  return question3() if round == 3

question0 = ->
  number = Math.floor(Math.random() * 10)

  question:
    start: number
  answer:
    end: number

question1 = ->
  start = Math.floor(Math.random() * 10)
  distance = Math.floor(Math.random() * 10) + 1

  question:
    start: start
    instructions: Array(distance + 1).join 'F'
  answer:
    end: start + distance

question2 = ->
  startX = Math.floor(Math.random() * 20) + 10
  startY = Math.floor(Math.random() * 20) + 10
  instructions = getInstructions(Math.floor(Math.random() * 10) + 10)
  endPosition = calculateEndPosition(instructions, [startX, startY])
  console.log(endPosition)

  question:
    startX: startX
    startY: startY
    instructions: instructions.toString()
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

calculateEndPosition = (instructions, startingCoordinate) ->
  instructions.reduce ((x,y) ->
    if (y == 'L') then [x[0], x[1] + 1]
    else if (y == 'R') then [x[0], x[1] - 1]
    else if (y == 'F') then [x[0] + 1, x[1]]
    else [x[0] - 1, x[1]]), startingCoordinate

question3 = ->
  startX = Math.floor(Math.random() * 20) + 10
  startY = Math.floor(Math.random() * 20) + 10
  instructions = getInstructions(Math.floor(Math.random() * 10) + 10)
  shouldFindTreasure = Math.floor(Math.random() * 2) == 1
  endPosition = calculateEndPosition(instructions, [startX, startY])
  treasureCoordinate = calculateTreasureCoordinate(instructions, shouldFindTreasure, [startX, startY])

  question:
    startX: startX
    startY: startY
    treasureX: treasureCoordinate[0]
    treasureY: treasureCoordinate[1]
    instructions: instructions.toString()
  answer:
    endX: endPosition[0]
    endY: endPosition[1]
    treasureFound: shouldFindTreasure

calculateTreasureCoordinate = (instructions, shouldFindTreasure, startingCoordinate) ->
  if(shouldFindTreasure)
    treasureAtMove = Math.floor(Math.random() * instructions.length)
    return calculateEndPosition(instructions.slice(0, treasureAtMove), startingCoordinate)
  else
    treasureX = Math.floor(Math.random() * 20) + 50
    treasureY = Math.floor(Math.random() * 20) + 50
    return [treasureX, treasureY]






