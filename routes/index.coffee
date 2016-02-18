exports.dashboard = (req, res) ->
  res.render 'dashboard', { title: 'CodeWhispers' }

exports.controlPanel = (req, res) ->
  res.render 'controlPanel', { title: 'CodeWhispers' }

exports.whisper = (req, res) ->
  getRound()
  .then (round) ->
    res.render "q#{round}", (err, q) ->
      res.render 'instructions', { title: 'CodeWhispers', q: q }
  .catch (error) ->
    res.status(500).send(error)

exports.question = (req, res) ->
  round = req.params['round']
  res.render "q#{round}"

getRound =  ->
  connection = require './connection'
  round = require './round'
  connection.open()
  .then (client) -> round.getRound client
