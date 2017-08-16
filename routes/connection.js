import {MongoClient} from 'mongodb'

let client = null;
let collections = {};

exports.init = function() {
  return MongoClient.connect('mongodb://127.0.0.1:27017/CodeWhispers')
  .then((db) => client = db);
};

exports.collection = function(collectionName) {
  if (!collections[collectionName]) {
    collections[collectionName] = client.collection(collectionName);
  }
  return collections[collectionName];
};
