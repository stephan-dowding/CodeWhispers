import round from './round'

exports.dashboard = function(req, res) {
  res.render('dashboard', {
    title: 'CodeWhispers'
  });
};

exports.controlPanel = function(req, res) {
  res.render('controlPanel', {
    title: 'CodeWhispers'
  });
};

exports.whisper = function(req, res) {
  round.getRound()
  .then((roundNumber) =>
    res.render("q" + roundNumber, (err, q) =>
      res.render('instructions', {
        title: 'CodeWhispers',
        q: q
      })
    )
  )
  .catch((error) => res.status(500).send(error));
};

exports.question = function(req, res) {
  var roundNumber;
  roundNumber = req.params['round'];
  return res.render("q" + roundNumber);
};
