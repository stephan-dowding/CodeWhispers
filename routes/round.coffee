connection = require './connection'

io = null
exports.initIo = (_io) ->
  io = _io
  io.on 'connection', (socket) ->
    connection.open (error, client) ->
      exports.getRound client, (round) ->
        client.close()
        socket.emit('new round', round)

exports.set = (req, res) ->
  number = req.body.number
  connection.open (error, client) ->
    setRound number, client, ->
      client.close()
      res.status(200).send("Round: #{number}")

exports.increment = (client, callback) ->
  getRound client, (round) ->
    round += 1
    setRound round, client, ->
      callback round

setRound = (number, client, callback) ->
  client.collection 'challenge', (err, collection) ->
    collection.remove {}, {safe:true}, (err, objects) ->
      client.collection 'round', (err, round) ->
        round.remove {}, {safe:true}, (err, objects) ->
          round.save {round: number}, {safe:true}, (err, objects) ->
            updateBranchEntries client, number, ->
              io.emit('new round', number)
              callback()

updateBranchEntries = (client, round, callback) ->
  branches = []
  client.collection 'branches', (err, collection) ->
    collection.find().each (err, doc) ->
      if doc
        branches.push doc
      else
        updateBranchEntry collection, client, branches, round, callback

updateBranchEntry = (collection, client, branches, round, callback) ->
  if branches.length == 0
    callback()
  else
    branch = branches[0]
    branch[round] = false unless branch[round]
    collection.save branch, {safe:true}, (err, objects) ->
      updateBranchEntry collection, client, branches.slice(1), round, callback

getRound = (client, callback) ->
  client.collection 'round', (err, round) ->
    round.findOne {}, (err, doc) ->
      callback doc.round
exports.getRound = getRound
