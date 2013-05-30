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
  checkEnd(reqBody, answer) if round == 0  || round == 1

checkEnd = (reqBody, answer) ->
  return reqBody['end'] == answer.end.toString()

generateQandA = (round) ->
  return question0() if round == 0
  return question1() if round == 1

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

