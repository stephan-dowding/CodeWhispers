import round from './round'
var fs = require("fs");

exports.dashboard = function(req, res) {
  res.render('dashboard', {
    title: 'CodeWhispers'
  });
};

exports.setupScript = function (req,res) {
    fs.readFile("public/teamPack/setup-whisper.sh","utf8" ,function(err, contents) {
        res.setHeader('Content-Type', 'text/x-shellscript');
        res.setHeader('Content-Disposition', 'attachment; filename=setup-whisper.sh');
        res.send(contents.replace("codewhispers.org",process.env.PUBLIC_HOSTNAME))
    })
}

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
