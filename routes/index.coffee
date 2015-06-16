exports.dashboard = (req, res) ->
  res.render 'dashboard', { title: 'ChineseWhispers' }

exports.whisper = (req, res) ->
  getRound res, (round) ->
    res.render "q#{round}", (err, q) ->
      res.render 'instructions', { title: 'ChineseWhispers', q: q }

exports.question = (req, res) ->
  getRound res, (round) ->
    res.render "q#{round}"

getRound = (res, callback) ->
  mongo = require 'mongodb'
  connection = require './connection'
  round = require './round'
  connection.open (error, client) ->
    round.getRound client, res, (round) ->
      callback round
