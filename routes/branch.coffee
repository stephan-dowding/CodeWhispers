swapper = require "../swapper/swapper"

exports.list = (req, res) ->
  swapper.getBranchList (branches) ->
    res.render 'branches',
      title: "Chinese Whispers"
      branches: branches
