
##
# Module dependencies.
##

express = require 'express'
routes = require './routes'
branch = require './routes/branch'
challenge = require './routes/challenge'
http = require 'http'
path = require 'path'

app = express()

# all environments
app.set 'port', process.env.PORT || 3000
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, 'public'))

# development only
if 'development' == app.get('env')
  app.use express.errorHandler()

app.get '/', routes.index
app.get '/branches', branch.list
app.get '/branches/swap', branch.swap

app.get '/challenge/question/:team', challenge.question

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
