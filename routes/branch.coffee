swapper = require "../swapper/swapper"
randomiser = require "../swapper/listRandomiser"

exports.list = (req, res) ->
  swapper.getBranchList (branches) ->
    res.render 'branches',
      title: "Chinese Whispers"
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
