mongo = require 'mongodb'

exports.open = (callback) ->
  server = new mongo.Server "127.0.0.1", 27017, {}
  connection = new mongo.Db 'CodeWhispers', server, {w: 1}
  connection.open (error, client) ->
    callback(error, client)
