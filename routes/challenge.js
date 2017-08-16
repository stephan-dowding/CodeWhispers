import connection from './connection'
import round from './round'
import checker from '../challenges/checker'

let io = null;

exports.initIo = function(_io) {
  io = _io;
};

exports.question = function(req, res) {
  let context = {};
  let challengeCollection = connection.collection('challenge');
  round.getRound()
  .then((round) => {
    context.round = round;
    let challenge = generateQandA(round);
    challenge.team = req.params['team'];
    context.challenge = challenge;
    return challengeCollection.findOne({
      team: challenge.team
    });
  })
  .then((oldChallenge) => {
    if (oldChallenge) {
      context.challenge._id = oldChallenge._id;
      if (oldChallenge.result && oldChallenge.count < requiredAttempts(context.round) && oldChallenge.round === context.round) {
        context.challenge.count = oldChallenge.count + 1;
      }
    }
    return challengeCollection.save(context.challenge, {
      safe: true
    });
  })
  .then(() => {
    if (context.challenge.count === 0) {
      io.emit('result', {
        team: context.challenge.team,
        round: context.round,
        status: 'working'
      });
    }
    res.json(context.challenge.question);
  })
  .catch((error) => {
    console.log(error);
    res.status(500).json(error);
  });
};

exports.answer = function(req, res) {
  let team = req.params['team'];
  let challengeCollection = connection.collection('challenge');
  let context = {};
  round.getRound()
  .then(function(round) {
    context.round = round;
    return challengeCollection.findOne({
      team: team
    });
  })
  .then((doc) => {
    doc.result = correct(req.body, doc.answer, context.round);
    context.doc = doc;
    return challengeCollection.save(doc, {
      safe: true
    });
  })
  .then(() => setResult(context.round, team, context.doc.result, context.doc.count))
  .then((status) => {
    if (status !== 'working') {
      io.emit('result', {
        team: team,
        round: context.round,
        status: status
      });
    }
    if (context.doc.result) {
      if (context.doc.count >= requiredAttempts(context.round)) {
        res.status(200).send("OK");
      } else {
        res.redirect(303, "/routes/challenge/" + team);
      }
    } else {
      res.status(418).json({
        yourAnswer: req.body,
        correctAnswer: context.doc.answer
      });
    }
  })
  .catch((error) => {
    console.log(error);
    res.status(500).json(error);
  });
};

let setResult = function(round, team, gotItRight, count) {
  let branchesCollection = connection.collection('branches');
  let status = null;
  return branchesCollection.findOne({
    name: team
  })
  .then((doc) => {
    if (!gotItRight) {
      status = 'failure';
    } else if (count === requiredAttempts(round)) {
      status = 'success';
    } else {
      status = 'working';
    }
    doc[round] = status;
    return branchesCollection.save(doc, {
      safe: true
    });
  })
  .then(() => status);
};

let requiredAttempts = function(round) {
  if (round === 0) return 2;
  return round * 5;
};

let correct = function(reqBody, answer, round) {
  return checker.check(answer, reqBody);
};

let generateQandA = function(round) {
  let challenge = require("../challenges/challenge" + round).challenge();
  challenge.round = round;
  challenge.count = 0;
  challenge.result = false;
  return challenge;
};
