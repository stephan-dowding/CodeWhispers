connection = require './connection'

io = null
exports.initIo = (_io) ->
  io = _io
  io.on 'connection', (socket) ->
    getRound()
      .then (round) ->
        socket.emit('new round', round)
      .catch (error) ->
        console.log error

exports.set = (req, res) ->
  number = req.body.number
  setRound number
    .then ->
      res.status(200).send("Round: #{number}")
    .catch (error) ->
      res.status(500).send(error)

exports.increment = ->
  getRound()
    .then (round) ->
      round += 1
      setRound round

setRound = (number) ->
  challenges = connection.collection 'challenge'
  round = connection.collection 'round'
  challenges.remove {}, {safe:true}
    .then ->
      round.remove {}, {safe:true}
    .then ->
      round.save {round: number}, {safe:true}
    .then ->
      io.emit('new round', number)
      number

getRound = ->
  roundCollection = connection.collection 'round'
  roundCollection.findOne {}
    .then (doc) -> doc.round

exports.getRound = getRound
