connection = require './connection'
branch = require './branch'
round = require './round'

exports.nextRound = (req, res) ->
  connection.open (error, client) ->
    if error
      client.close()
      res.status(500).send(error)
    else
      branch.performSwap client, (branchMapping) ->
        round.increment client
        .then (number) ->
          res.status(200).json
            round: number
            mapping: branchMapping
        .catch (error) ->
          res.status(500).send(error)
        .finally ->
          client.close()
