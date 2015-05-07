mongo = require 'mongodb'

connection = require './connection'

exports.set = (req, res) ->
  number = parseInt req.params['number']

  connection.open (error, client) ->
    client.collection 'challenge', (err, collection) ->
      collection.remove {}, {safe:true}, (err, objects) ->
        if err
          client.close()
          res.send(500, err)
        else
          client.collection 'round', (err, round) ->
            round.remove {}, {safe:true}, (err, objects) ->
              if err
                client.close()
                res.send(500, err)
              else
                round.save {round: number}, {safe:true}, (err, objects) ->
                  if err
                    client.close()
                    res.send(500, err)
                  else
                    updateBranchEntries client, res, number, ->
                      client.close()
                      res.send(200, "Round: #{number}")

updateBranchEntries = (client, res, round, callback) ->
  branches = []
  client.collection 'branches', (err, collection) ->
    collection.find().each (err, doc) ->
      if err
        client.close()
        res.send(500, err)
      else if doc
        branches.push doc
      else
        updateBranchEntry collection, client, res, branches, round, callback

updateBranchEntry = (collection, client, res, branches, round, callback) ->
  if branches.length == 0
    callback()
  else
    branch = branches[0]
    branch[round] = false unless branch[round]
    collection.save branch, {safe:true}, (err, objects) ->
      if err
        client.close()
        res.send(500, err)
      else
        updateBranchEntry collection, client, res, branches.slice(1), round, callback

exports.getRound = (client, res, callback) ->
  client.collection 'round', (err, round) ->
    round.findOne {}, (err, doc) ->
      if err
        client.close()
        res.send 500, err
      else
        callback doc.round
