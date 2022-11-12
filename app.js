import express from 'express'
import routes from './routes/index'
import branch from './routes/branch'
import challenge from './routes/challenge'
import round from './routes/round'
import action from './routes/action'
import http from 'http'
import path from 'path'
import bodyParser from 'body-parser'

let app = express();
let server = http.createServer(app);
let io = require('socket.io')(server);

app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');
app.use(express["static"](path.join(__dirname, 'public')));
app.use(bodyParser.json());
app.use(require("connect-assets")({
  paths: ['assets/css', 'assets/js', 'assets/img'],
  fingerprinting: false
}));
app.get('/setup-whisper.sh', routes.setupScript)
app.get('/dashboard', routes.dashboard);
app.get('/control-panel', routes.controlPanel);
app.get('/', routes.whisper);
app.get('/question/:round', routes.question);
app.get('/branches', branch.list);
app.get('/details', branch.getDetails);

app.post('/branches', branch.swap);
app.post('/round', round.set);
app.post('/action/next-round', action.nextRound);

app.get('/challenge/question/:team', challenge.question);
app.post('/challenge/answer/:team', challenge.answer);

app.put('/teams/:team', branch.add);
app.post('/teams/:team/commits', branch.addCommits);
app.delete('/teams/:team', branch.remove);

require('./routes/connection').init()
.then(() => branch.rescan())
.then(() => {
  round.initIo(io.of('/round'));
  branch.initIo(io.of('/teams'));
  challenge.initIo(io.of('/challenge'));
  server.listen(app.get('port'), () => console.log('Express server listening on port ' + app.get('port')));
})
.catch((error) => {
  console.error(error);
  process.exit(1);
});
