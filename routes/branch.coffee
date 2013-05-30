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
  connection.open (error, client) ->
    if error
      client.close()
      res.send(500, error)
    else
      round.getRound client, res, (round) ->
        if round == 0
          syncBranches res, client, ->
            sendBranchList client, res, round
        else
          sendBranchList client, res, round

syncBranches = (res, client, callback) ->
  swapper.getBranchList (branches) ->
    ensureExists res, client, branches, ->
      callback()

ensureExists = (res, client, branches, callback) ->
  if branches.length == 0
    callback()
  else
    collection = new mongo.Collection client, 'branches'
    collection.findOne {name: branches[0]}, (err, doc) ->
      if err
        client.close()
        res.send(500, err)
      else if doc
        ensureExists res, client, branches.slice(1), callback
      else
        collection.save {name: branches[0], 0: false}, {safe:true}, (err, objects) ->
          if err
            client.close()
            res.send(500, err)
          else
            ensureExists res, client, branches.slice(1), callback

sendBranchList = (client, res, round) ->
  getBranches client, res, (branches) ->
    client.close()
    res.send
      round: round
      branches: branches

getBranches = (client, res, callback) ->
  branches = []
  collection = new mongo.Collection client, 'branches'
  collection.find().each (err, doc) ->
    if err
      client.close()
      res.send(500, err)
    else if doc
      branches.push doc.name
    else
      callback(branches)

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
