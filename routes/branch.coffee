swapper = require "../swapper/swapper"
randomiser = require "../swapper/listRandomiser"

mongo = require 'mongodb'
connection = require './connection'

round = require './round'

exports.list = (req, res) ->
  swapper.getBranchList (branches) ->
    res.render 'branches',
      title: "Code Whispers"
      branches: branches

exports.getDetails = (req, res) ->
  connection.open (error, client) ->
    if error
      client.close()
      res.send(500, error)
    else
      round.getRound client, res, (round) ->
        sendBranchList client, res, round

sendBranchList = (client, res, round) ->
  getBranches client, res, (branches) ->
    client.close()
    res.send
      round: round
      branches: branches

getBranches = (client, res, callback) ->
  branches = []
  client.collection 'branches', (err, collection) ->
    collection.find().each (err, doc) ->
      if err
        client.close()
        res.send(500, err)
      else if doc
        branches.push doc
      else
        callback(branches)

exports.rescan = ->
  swapper.getBranchList (branches) ->
    connection.open (error, client) ->
      ensureExists client, branches, ->
        cleanBranches client, branches, ->
          client.close()

ensureExists = (client, branches, callback) ->
  if branches.length == 0
    callback()
  else
    client.collection 'branches', (err, collection) ->
      collection.findOne {name: branches[0]}, (err, doc) ->
        if err
          client.close()
        else if doc
          ensureExists client, branches.slice(1), callback
        else
          collection.save {name: branches[0], 0: false}, {safe:true}, (err, objects) ->
            if err
              client.close()
            else
              ensureExists client, branches.slice(1), callback

cleanBranches = (client, rawBranches, callback) ->
  client.collection 'branches', (err, collection) ->
    collection.remove {name: {$nin: rawBranches}}, {safe:true}, (err, doc) ->
      if err
        client.close()
      else
        callback()

exports.add = (req, res) ->
  name = req.params['team']
  connection.open (error, client) ->
    if error
      client.close()
      res.send(500, error)
    else
      ensureExists client, [name], ->
        res.send(200)

exports.remove = (req, res) ->
  name = req.params['team']
  connection.open (error, client) ->
    if error
      client.close()
      res.send(500, error)
    else
      client.collection 'branches', (err, collection) ->
        collection.remove {name: name}, {safe:true}, (err, doc) ->
          res.send(200)

exports.swap = (req, res) ->
  connection.open (error, client) ->
    if error
      client.close()
      res.send(500, error)
    else
      getBranches client, res, (branches) ->
        sourceBranches = branches.map (item) ->
          item.name
        targetBranches = randomiser.randomise sourceBranches
        swapper.swapBranches sourceBranches, targetBranches, ->
          client.close()
          res.render 'branchMapping',
            title: "Code Whispers"
            branchMapping: entangle sourceBranches, targetBranches

entangle = (origin, destination) ->
  mapping = []
  for i in [0...origin.length]
    mapping.push
      origin: origin[i]
      destination: destination[i]
  mapping
