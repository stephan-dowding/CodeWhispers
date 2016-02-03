syncLock = require "../util/syncLock"

if typeof String.prototype.endsWith != 'function'
  String.prototype.endsWith = (str) ->
    this.slice(-str.length) == str

exec = require('child_process').exec

gitOptions =
  cwd: process.cwd() + "/git-master"

gitPull = (callback) ->
  console.log "fetch"
  exec "git remote prune origin", gitOptions, (error, stdout, stderr) ->
    exec "git fetch --all", gitOptions, (error, stdout, stderr) ->
      callback()

resetLocalBranches = (branches, callback) ->
  if branches.length == 0
    console.log "checkout master"
    exec "git checkout master", gitOptions, (error, stdout, stderr) ->
      callback()
  else
    console.log "checkout #{branches[0]}"
    exec "git checkout #{branches[0]}", gitOptions, (error, stdout, stderr) ->
      exec "git reset origin/#{branches[0]}", gitOptions, (error, stdout, stderr) ->
        resetLocalBranches branches.slice(1), callback

renameLocalsToTemp = (branches, callback) ->
  if branches.length == 0
    callback()
  else
    exec "git branch --unset-upstream #{branches[0]}", gitOptions, (error, stdout, stderr) ->
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
    callback()
  else
    console.log "checkout #{branches[0]} and stuff"
    exec "git checkout #{branches[0]}", gitOptions, (error, stdout, stderr) ->
      exec "git push -uf origin #{branches[0]}", gitOptions, (error, stdout, stderr) ->
        reconnectBranches branches.slice(1), callback


checkoutMaster = (callback) ->
  console.log "checkout master"
  exec "git checkout master", gitOptions, (error, stdout, stderr) ->
    callback()

swapBranches = (branches, targetBranches, callback) ->
  syncLock.lock ->
    checkoutMaster ->
      gitPull ->
        resetLocalBranches branches, ->
          renameLocalsToTemp branches, ->
            renameLocalsFromTemp branches, targetBranches, ->
              reconnectBranches branches, ->
                checkoutMaster ->
                  callback()
                  syncLock.release()

getBranchList = (callback) ->
  syncLock.lock ->
    gitPull ->
      exec "git branch -r", gitOptions, (error, stdout, stderr) ->
        branches = []
        lines = stdout.toString().split "\n"

        for line in lines
          branches.push line.substr(line.lastIndexOf("/") + 1)  if line && !(line.endsWith "/master")

        callback(branches)
        syncLock.release()


exports.swapBranches = swapBranches
exports.getBranchList = getBranchList
