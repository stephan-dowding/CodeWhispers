exports.dashboard = (req, res) ->
  res.render 'dashboard', { title: 'ChineseWhispers' }

exports.whisper = (req, res) ->
  mongo = require 'mongodb'
  connection = require './connection'
  round = require './round'
  connection.open (error, client) ->
    round.getRound client, res, (round) ->
      res.render "q#{round}", { title: 'ChineseWhispers' }
