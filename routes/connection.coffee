mongoClient = require('mongodb').MongoClient

exports.open = (callback) ->
  mongoClient.connect 'mongodb://127.0.0.1:27017/CodeWhispers', (error, client) ->
    callback(error, client)
