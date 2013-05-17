randomiser = require "./listRandomiser"
swapper = require "./swapper"

# targetBranches = randomise branches
#   console.log branches
#   console.log targetBranches

#   swapBranches(branches, targetBranches)

list = [1..10]
randomised = randomiser.randomise list
console.log list
console.log randomised

swapper.getBranchList (branches)->
  targetBranches = randomiser.randomise branches
  swapper.swapBranches branches, targetBranches, ->
    console.log "Done!"
