if typeof String.prototype.endsWith != 'function'
  String.prototype.endsWith = (str) ->
    this.slice(-str.length) == str

exec = require('child_process').exec

gitOptions =
  cwd: process.cwd() + "/git-master"

gitPull = (callback) ->
  console.log "pull"
  exec "git pull", gitOptions, (error, stdout, stderr) ->
    callback()

cycleBranches = (branches, callback) ->
  if branches.length == 0
    console.log "checkout master"
    exec "git checkout master", gitOptions, (error, stdout, stderr) ->
      callback()
  else
    console.log "checkout #{branches[0]}"
    exec "git checkout #{branches[0]}", gitOptions, (error, stdout, stderr) ->
      cycleBranches branches.slice(1), callback

deleteServerBranches = (branches, callback) ->
  if branches.length == 0
    callback()
  else
    exec "git push origin :#{branches[0]}", gitOptions, (error, stdout, stderr) ->
      deleteServerBranches branches.slice(1), callback

renameLocalsToTemp = (branches, callback) ->
  if branches.length == 0
    callback()
  else
    exec "git branch -m #{branches[0]} temp__#{branches[0]}", gitOptions, (error, stdout, stderr) ->
      renameLocalsToTemp branches.slice(1), callback

renameLocalsFromTemp = (branches, targetBranches, callback) ->
  if branches.length == 0
    callback()
  else
    exec "git branch -m temp__#{branches[0]} #{targetBranches[0]}", gitOptions, (error, stdout, stderr) ->
      renameLocalsFromTemp branches.slice(1), targetBranches.slice(1), callback

reconnectBranches = (branches, callback) ->
  if branches.length == 0
    console.log "checkout master"
    exec "git checkout master", gitOptions, (error, stdout, stderr) ->
      callback()
  else
    console.log "checkout #{branches[0]} and stuff"
    exec "git checkout #{branches[0]}", gitOptions, (error, stdout, stderr) ->
      exec "git push origin #{branches[0]}", gitOptions, (error, stdout, stderr) ->
        exec "git branch --set-upstream #{branches[0]} origin/#{branches[0]}", gitOptions, (error, stdout, stderr) ->
          reconnectBranches branches.slice(1), callback

swapBranches = (branches, targetBranches, callback) ->
  gitPull ->
    cycleBranches branches, ->
      deleteServerBranches branches, ->
        renameLocalsToTemp branches, ->
          renameLocalsFromTemp branches, targetBranches, ->
            reconnectBranches branches, ->
              callback()

getBranchList = (callback) ->
  gitPull ->
    exec "git branch -r", gitOptions, (error, stdout, stderr) ->
      branches = []
      lines = stdout.toString().split "\n"

      for line in lines
        branches.push line.substr(line.lastIndexOf("/") + 1)  if line && !(line.endsWith "master")

      callback(branches)


exports.swapBranches = swapBranches
exports.getBranchList = getBranchList
