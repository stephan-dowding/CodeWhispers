mongo = require 'mongodb'

connection = require './connection'

exports.question = (req, res) ->
  question = generateQuestion()

  answer = calculateAnswer question

  challenge =
    team: req.params['team']
    question: question
    answer: answer

  connection.open (error, client) ->
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
            res.json question

exports.answer = (req, res) ->
  team = req.params['team']
  answer = req.body['answer']

  connection.open (error, client) ->
    collection = new mongo.Collection client, 'challenge'
    collection.findOne {team: team}, (err, doc) ->
      client.close()
      if err
        res.send(500, err)
      else
        console.log doc
        console.log "Response: #{answer}"
        if doc.answer.toString() == answer
          res.send(200, "OK")
        else
          res.send(418, "D'oh!")

generateQuestion = ->
  s: Math.floor(Math.random() * 10)
  i: Array(Math.floor(Math.random() * 10) + 2).join 'M'

calculateAnswer = (question) ->
  question.s + question.i.length
