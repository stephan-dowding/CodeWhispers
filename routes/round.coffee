mongo = require 'mongodb'

connection = require './connection'

exports.set = (req, res) ->
  number = parseInt req.params['number']

  connection.open (error, client) ->
    collection = new mongo.Collection client, 'challenge'
    collection.remove {}, {safe:true}, (err, objects) ->
      if err
        client.close()
        res.send(500, err)
      else
        round = new mongo.Collection client, 'round'
        round.remove {}, {safe:true}, (err, objects) ->
          if err
            client.close()
            res.send(500, err)
          else
            round.save {round: number}, {safe:true}, (err, objects) ->
              client.close()
              if err
                res.send(500, err)
              else
                res.send(200, "Round: #{number}")

exports.getRound = (client, callback) ->
  round = new mongo.Collection client, 'round'
  round.findOne {}, (err, doc) ->
    if err
      callback err
    else
      callback null, doc.round
