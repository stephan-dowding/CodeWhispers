connection = require './connection'

io = null
exports.initIo = (_io) ->
  io = _io
  io.on 'connection', (socket) ->
    context = {}
    connection.open()
    .then (client) ->
      context.client = client
      getRound context.client
    .then (round) ->
      socket.emit('new round', round)
    .catch (error) ->
      console.log error
    .finally ->
      context.client.close() if context.client


exports.set = (req, res) ->
  number = req.body.number
  context = {}
  connection.open()
  .then (client) ->
    context.client = client
    setRound number, client
  .then ->
    res.status(200).send("Round: #{number}")
  .catch (error) ->
    res.status(500).send(error)
  .finally ->
    context.client.close() if context.client

exports.increment = (client) ->
  getRound client
  .then (round) ->
    round += 1
    setRound round, client

setRound = (number, client) ->
  challenges = client.collection 'challenge'
  round = client.collection 'round'
  challenges.remove {}, {safe:true}
  .then ->
    round.remove {}, {safe:true}
  .then ->
    round.save {round: number}, {safe:true}
  .then ->
    io.emit('new round', number)
    number

getRound = (client) ->
  roundCollection = client.collection 'round'
  roundCollection.findOne {}
  .then (doc) -> doc.round

exports.getRound = getRound
