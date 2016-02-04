
##
# Module dependencies.
##

express = require 'express'
routes = require './routes/index'
branch = require './routes/branch'
challenge = require './routes/challenge'
round = require './routes/round'
http = require 'http'
path = require 'path'
bodyParser = require('body-parser')

app = express()

server = http.createServer(app)
io = require('socket.io')(server)

round.initIo io.of('/round')
branch.initIo io.of('/teams')
challenge.initIo io.of('/challenge')

# all environments
app.set 'port', process.env.PORT || 3000
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.use express.static(path.join(__dirname, 'public'))
app.use bodyParser.json()

app.use(require("connect-assets")({
  paths: [
    'assets/css',
    'assets/js',
    'assets/img'
  ],
  fingerprinting: false
}))

app.get '/dashboard', routes.dashboard
app.get '/', routes.whisper
app.get '/question/:round', routes.question
app.get '/branches', branch.list
app.get '/details', branch.getDetails
app.get '/branches/swap', branch.swap
app.get '/round/:number', round.set

app.get '/challenge/question/:team', challenge.question
app.post '/challenge/answer/:team', challenge.answer

app.put '/teams/:team', branch.add
app.delete '/teams/:team', branch.remove

branch.rescan()

server.listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
