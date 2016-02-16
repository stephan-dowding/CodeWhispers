exports.dashboard = (req, res) ->
  res.render 'dashboard', { title: 'CodeWhispers' }

exports.controlPanel = (req, res) ->
  res.render 'controlPanel', { title: 'CodeWhispers' }

exports.whisper = (req, res) ->
  getRound (round) ->
    res.render "q#{round}", (err, q) ->
      res.render 'instructions', { title: 'CodeWhispers', q: q }

exports.question = (req, res) ->
  round = req.params['round']
  res.render "q#{round}"

getRound = (callback) ->
  connection = require './connection'
  round = require './round'
  connection.open (error, client) ->
    round.getRound client, (round) ->
      callback round
