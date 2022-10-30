import connection from './connection'

let io = null;

exports.initIo = function(_io) {
  io = _io;
  io.on('connection', (socket) =>
    getRound()
    .then((round) => socket.emit('new round', round))
    .catch((error) => console.log(error))
  );
};

exports.set = function(req, res) {
  let number = req.body.number;
  setRound(number)
  .then(() => res.status(200).send("Round: " + number))
  .catch((error) => res.status(500).send(error));
};

exports.increment = function() {
  return getRound()
  .then((round) => {
    round += 1;
    return setRound(round);
  });
};

let setRound = function(number) {
  let challenges = connection.collection('challenge');
  let round = connection.collection('round');
  return challenges.remove({}, { safe: true })
  .then(() => round.remove({}, { safe: true }))
  .then(() => round.save({ round: number }, { safe: true }))
  .then(() => {
    io.emit('new round', number);
    return number;
  });
};

let getRound = function() {
  let roundCollection = connection.collection('round');
  return roundCollection.findOne({})
    .then((doc) => (doc || { round: 0}).round);
};

exports.getRound = getRound;
