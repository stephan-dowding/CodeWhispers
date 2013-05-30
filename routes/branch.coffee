swapper = require "../swapper/swapper"
randomiser = require "../swapper/listRandomiser"

mongo = require 'mongodb'
connection = require './connection'

round = require './round'

exports.list = (req, res) ->
  swapper.getBranchList (branches) ->
    res.render 'branches',
      title: "Chinese Whispers"
      branches: branches

exports.getDetails = (req, res) ->
  swapper.getBranchList (branches) ->
    connection.open (error, client) ->
      if error
        client.close()
        res.send(500, error)
      else
        round.getRound client, (err, round) ->
          client.close()
          if err
            res.send(500, error)
          else
            res.send
              round: round
              branches: branches

exports.swap = (req, res) ->
  swapper.getBranchList (branches) ->
    targetBranches = randomiser.randomise branches
    swapper.swapBranches branches, targetBranches, ->
      res.render 'branchMapping',
        title: "Chinese Whispers"
        branchMapping: entangle branches, targetBranches

entangle = (origin, destination) ->
  map = []
  for i in [0...origin.length]
    map.push
      origin: origin[i]
      destination: destination[i]
  map
