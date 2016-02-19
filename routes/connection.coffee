mongoClient = require('mongodb').MongoClient

client = null
collections = {}

exports.init = ->
  mongoClient.connect 'mongodb://127.0.0.1:27017/CodeWhispers'
  .then (db) ->
    client = db

exports.collection = (collectionName) ->
  collections[collectionName] = client.collection collectionName unless collections[collectionName]
  collections[collectionName]


exports.open = (callback) ->
  promise = mongoClient.connect 'mongodb://127.0.0.1:27017/CodeWhispers'
  return promise unless callback
  promise.then (db) ->
    callback(null, db)
  .catch (error) ->
    callback(error, null)
