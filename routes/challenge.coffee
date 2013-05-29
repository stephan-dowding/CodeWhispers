mongo = require 'mongodb'

server = new mongo.Server "127.0.0.1", 27017, {}
connection = new mongo.Db 'ChineseWhispers', server, {w: 1}
dbClient = {}
connection.open (error, client) ->
  if error
    process.exit 1
  else
    dbClient = client

exports.question = (req, res) ->
  question = generateQuestion()

  answer = calculateAnswer question

  challenge =
    team: req.params['team']
    question: question
    answer: answer

  collection = new mongo.Collection dbClient, 'challenge'
  collection.remove {team: challenge.team}, {safe:true}, (err, objects) ->
    if err
      res.send(500, err)
    else
      collection.save challenge, {safe:true}, (err, objects) ->
        if err
          res.send(500, err)
        else
          res.json question

exports.answer = (req, res) ->
  team = req.params['team']
  answer = req.body['answer']

  collection = new mongo.Collection dbClient, 'challenge'
  collection.findOne {team: team}, (err, doc) ->
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
