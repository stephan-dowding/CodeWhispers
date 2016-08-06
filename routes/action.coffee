connection = require './connection'
branch = require './branch'
round = require './round'

exports.nextRound = (req, res) ->
  branch.performSwap (branchMapping) ->
    round.increment()
      .then (number) ->
        res.status(200).json
          round: number
          mapping: branchMapping
      .catch (error) ->
        res.status(500).send(error)
