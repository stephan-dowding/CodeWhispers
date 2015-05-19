mongo = require 'mongodb'

connection = require './connection'

round = require './round'

exports.question = (req, res) ->

  connection.open (error, client) ->
    round.getRound client, res, (round) ->

      challenge = generateQandA(round)
      challenge.team = req.params['team']

      client.collection 'challenge', (err, collection) ->
        collection.findOne {team: challenge.team}, (err, old_challenge) ->
          if err
            client.close()
            res.send(500, err)
          else
            if old_challenge
              challenge._id = old_challenge._id
              challenge.count = old_challenge.count + 1 if old_challenge.result && old_challenge.count < 10 && old_challenge.round == round
            console.log "Challenge -- #{challenge.team}"
            console.log challenge
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

      client.collection 'challenge', (err, collection) ->
        collection.findOne {team: team}, (err, doc) ->
          if err
            client.close()
            res.send(500, err)
          else
            gotItRight = correct(req.body, doc.answer, round)
            doc.result = gotItRight
            collection.save doc, {safe:true}, (err, objects) ->
              if err
                client.close()
                res.send(500, err)
              else
                console.log "Answer -- #{team}"
                console.log doc
                console.log req.body
                setResult client, res, round, team, gotItRight, doc.count, ->
                  client.close()
                  if gotItRight
                    if doc.count == 10
                      res.send(200, "OK")
                    else
                      res.redirect(303, "/routes/challenge/#{team}")
                  else
                    res.send(418, "D'oh!")

setResult = (client, res, round, team, gotItRight, count, callback) ->
  client.collection 'branches', (err, collection) ->
    collection.findOne {name: team}, (err, doc) ->
      if err
        client.close()
        res.send(500, err)
      else if doc
        doc[round] = gotItRight && count == 10
        collection.save doc, {safe:true}, (err, objects) ->
          if err
            client.close()
            res.send(500, err)
          else
            callback()
      else
        callback()

correct = (reqBody, answer, round) ->
  return checkEnd(reqBody, answer) if round == 0 || round == 1
  return checkEndCoordinate(reqBody, answer) if round == 2
  return checkEndCoordinateWithTreasureFound(reqBody, answer) if round ==3
  return checkEndCoordinateWithTreasureFoundAndStolen(reqBody, answer) if round == 4 || round == 5

checkEnd = (reqBody, answer) ->
  try
    return parseInt(reqBody['end'], 10) == answer.end
  catch e
    return false

checkEndCoordinate = (reqBody, answer) ->
  try
    return parseInt(reqBody['endX'], 10) == answer.endX and parseInt(reqBody['endY'], 10) == answer.endY
  catch e
    return false

checkEndCoordinateWithTreasureFound = (reqBody, answer) ->
  return checkEndCoordinate(reqBody, answer) and reqBody['treasureFound'] == answer.treasureFound.toString()

checkEndCoordinateWithTreasureFoundAndStolen = (reqBody, answer) ->
  return false unless checkEndCoordinateWithTreasureFound(reqBody, answer)
  return reqBody['treasureStolen'] == answer.treasureStolen.toString()

generateQandA = (round) ->
  challenge = question0() if round == 0
  challenge = question1() if round == 1
  challenge = question2() if round == 2
  challenge = question3() if round == 3
  challenge = question4() if round == 4
  challenge = question5() if round == 5
  challenge.round = round
  challenge.count = 0
  challenge.result = false
  return challenge

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

calculateEndPosition = (instructions, startingCoordinate) ->
  instructions.reduce ((x,y) ->
    if (y == 'L') then [x[0], x[1] + 1]
    else if (y == 'R') then [x[0], x[1] - 1]
    else if (y == 'F') then [x[0] + 1, x[1]]
    else [x[0] - 1, x[1]]), startingCoordinate

question3 = (startingCoordinate)->
  if startingCoordinate
    startX = startingCoordinate[0]
    startY = startingCoordinate[1]
  else
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
    instructions: instructions.join ''
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


question4 = (startingCoordinate)->
  challenge = question3(startingCoordinate)
  pirateFound = Math.floor(Math.random() * 2) == 1

  if pirateFound
    challenge.question.pirateX = challenge.answer.endX
    challenge.question.pirateY = challenge.answer.endY
  else
    challenge.question.pirateX = challenge.answer.endX + 25
    challenge.question.pirateY = challenge.answer.endY + 25

  furtherMoves = getInstructions(Math.floor(Math.random() * 4) + 3)
  newEnd = calculateEndPosition furtherMoves, [challenge.answer.endX, challenge.answer.endY]
  challenge.question.instructions += furtherMoves.join ''
  challenge.answer.endX = newEnd[0]
  challenge.answer.endY = newEnd[1]
  challenge.answer.treasureStolen = pirateFound && challenge.answer.treasureFound
  challenge

question5 = ->
  initialMoves = getInstructions(Math.floor(Math.random() * 4) + 3)
  spyFound = Math.floor(Math.random() * 2) == 1

  startX = Math.floor(Math.random() * 20) + 10
  startY = Math.floor(Math.random() * 20) + 10

  spyCoord = calculateEndPosition initialMoves, [startX, startY]

  challenge = question4(spyCoord)
  challenge.question.instructions = initialMoves.join('') + challenge.question.instructions
  challenge.question.startX = startX
  challenge.question.startY = startY

  if spyFound
    challenge.question.spyX = spyCoord[0]
    challenge.question.spyY = spyCoord[1]
  else
    challenge.question.spyX = spyCoord[0] + 30
    challenge.question.spyY = spyCoord[1] + 30

  challenge.answer.treasureStolen = challenge.answer.treasureFound && (challenge.answer.treasureStolen != spyFound)
  challenge
