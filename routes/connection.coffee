mongoClient = require('mongodb').MongoClient

exports.open = (callback) ->
  promise = mongoClient.connect 'mongodb://127.0.0.1:27017/CodeWhispers', {promiseLibrary: global.Promise}
  return promise unless callback
  promise.then (client) ->
    callback(null, client)
  .catch (error) ->
    callback(error, null)
