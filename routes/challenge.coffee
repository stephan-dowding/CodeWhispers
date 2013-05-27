mongo = require 'mongodb'

server = new mongo.Server "127.0.0.1", 27017, {}
connection = new mongo.Db 'ChineseWhispers', server, {w: 1}

exports.question = (req, res) ->
  question = generateQuestion()

  answer = calculateAnswer question

  challenge =
    team: req.params['team']
    question: question
    answer: answer

  connection.open (error, client) ->
    if error
      res.send(500, error)
    else
      collection = new mongo.Collection client, 'challenge'
      collection.remove {team: challenge.team}, {safe:true}, (err, objects) ->
        if err
          res.send(500, err)
        else
          collection.save challenge, {safe:true}, (err, objects) ->
            if err
              res.send(500, err)
            else
              res.json question


generateQuestion = ->
  s: Math.floor(Math.random() * 10)
  i: Array(Math.floor(Math.random() * 10) + 2).join 'M'

calculateAnswer = (question) ->
  question.s + question.i.length
