mongo = require 'mongodb'
connection = require './connection'
round = require './round'
checker = require '../challenges/checker'

io = null
exports.initIo = (_io) ->
  io = _io

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
              challenge.count = old_challenge.count + 1 if old_challenge.result && old_challenge.count < requiredAttempts(round) && old_challenge.round == round
            console.log "Challenge -- #{challenge.team}"
            console.log challenge
            collection.save challenge, {safe:true}, (err, objects) ->
              client.close()
              if err
                res.send(500, err)
              else
                io.emit 'result', {team: challenge.team, round: round, status: 'working'} if challenge.count == 0
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
                setResult client, res, round, team, gotItRight, doc.count, (status) ->
                  client.close()
                  io.emit 'result', {team: team, round: round, status: status} unless status == 'working'
                  if gotItRight
                    if doc.count >= requiredAttempts(round)
                      res.send(200, "OK")
                    else
                      res.redirect(303, "/routes/challenge/#{team}")
                  else
                    res.status(418).json({yourAnswer: req.body, correctAnswer: doc.answer})

setResult = (client, res, round, team, gotItRight, count, callback) ->
  client.collection 'branches', (err, collection) ->
    collection.findOne {name: team}, (err, doc) ->
      if err
        client.close()
        res.send(500, err)
      else if doc
        unless gotItRight
          doc[round] = 'failure'
        else if count == requiredAttempts(round)
          doc[round] = 'success'
        else
          doc[round] = 'working'
        collection.save doc, {safe:true}, (err, objects) ->
          if err
            client.close()
            res.send(500, err)
          else
            callback(doc[round])
      else
        callback(gotItRight ? 'success' : 'failure')

requiredAttempts = (round) ->
  return 2 if round == 0
  return round * 5

correct = (reqBody, answer, round) ->
  checker.check(answer, reqBody)

generateQandA = (round) ->
  challenge = require("../challenges/challenge#{round}").challenge()
  challenge.round = round
  challenge.count = 0
  challenge.result = false
  return challenge
