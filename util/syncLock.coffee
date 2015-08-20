locked = false
queue = []

exports.lock = (callback) ->
  if !locked
    console.log "Not locked... locking"
    locked = true
    callback()
  else
    console.log "Locked... queueing"
    queue.push(callback)

exports.release = ->
  callback = queue.shift()
  if callback
    console.log "passing lock to next queued item"
    callback()
  else
    console.log "unlocking"
    locked = false
