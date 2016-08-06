round = require './round'

exports.dashboard = (req, res) ->
  res.render 'dashboard', { title: 'CodeWhispers' }

exports.controlPanel = (req, res) ->
  res.render 'controlPanel', { title: 'CodeWhispers' }

exports.whisper = (req, res) ->
  round.getRound()
    .then (roundNumber) ->
      res.render "q#{roundNumber}", (err, q) ->
        res.render('instructions', { title: 'CodeWhispers', q: q })
    .catch (error) ->
      res.status(500).send(error)

exports.question = (req, res) ->
  roundNumber = req.params['round']
  res.render "q#{roundNumber}"
