swapper = require "../swapper/swapper"
randomiser = require "../swapper/listRandomiser"

connection = require './connection'

round = require './round'

io = null
exports.initIo = (_io) ->
  io = _io

exports.list = (req, res) ->
  getBranches()
  .then (branches) ->
    res.render 'branches',
      title: "Code Whispers"
      branches: branches
  .catch (error) ->
    res.status(500).json(error)

exports.getDetails = (req, res) ->
  Promise.all [round.getRound(), getBranches()]
  .then ([round, branches]) ->
    res.send
      round: round
      branches: branches
  .catch (error) ->
    res.status(500).json(error)

getBranches =  ->
  collection = connection.collection 'branches'
  collection.find().toArray()

exports.rescan = ->
  swapper.getBranchList (branches) ->
    ensureExists branches
    .then ->
      cleanBranches branches

ensureExists = (branches) ->
  if branches.length == 0
    Promise.resolve()
  else
    collection = connection.collection 'branches'
    collection.findOne {name: branches[0]}
    .then (doc) ->
      collection.save {name: branches[0]}, {safe:true} unless doc
    .then ->
      ensureExists branches.slice(1)

cleanBranches = (rawBranches) ->
  collection = connection.collection 'branches'
  collection.remove {name: {$nin: rawBranches}}, {safe:true}

exports.add = (req, res) ->
  name = req.params['team']
  ensureExists [name], ->
    io.emit('new team', name)
    res.send(200)

exports.remove = (req, res) ->
  name = req.params['team']
  collection = connection.collection 'branches'
  collection.remove {name: name}, {safe:true}
  .then (doc) ->
    io.emit('remove team', name)
    res.send(200)
  .catch (error) ->
    res.status(500).json(error)

exports.swap = (req, res) ->
  performSwap (branchMapping) ->
    res.render 'branchMapping',
      title: "Code Whispers"
      branchMapping: branchMapping

performSwap = (callback) ->
  getBranches()
  .then (branches) ->
    sourceBranches = branches.map (item) -> item.name
    targetBranches = randomiser.randomise sourceBranches
    swapper.swapBranches sourceBranches, targetBranches, ->
      branchMapping = entangle sourceBranches, targetBranches
      callback(branchMapping)

exports.performSwap = performSwap

entangle = (origin, destination) ->
  mapping = []
  for i in [0...origin.length]
    mapping.push
      origin: origin[i]
      destination: destination[i]
  mapping
