if typeof String.prototype.startsWith != 'function'
  String.prototype.startsWith = (str) ->
    this.slice(0, str.length) == str

exec = require('child_process').exec
gitOptions =
  cwd: process.cwd()

getTeamName = (callback) ->
  console.log "getting Team Name"
  exec "git branch", gitOptions, (error, stdout, stderr) ->
    branches = []
    lines = stdout.toString().split "\n"
    for line in lines
      if line.startsWith("* ")
        console.log line
        callback(line.substring(2))

getTeamName (teamName) ->
  exec "git pull", gitOptions, (error, stdout, stderr) ->
    exec "git reset --hard origin/#{teamName}", gitOptions, (error, stdout, stderr) ->
      console.log "Reconnected to #{teamName}"



