challenge = ->
  start = Math.floor(Math.random() * 10)
  distance = Math.floor(Math.random() * 10) + 1

  question:
    start: start
    instructions: Array(distance + 1).join 'F'
  answer:
    end: start + distance

exports.challenge = challenge
