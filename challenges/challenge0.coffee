challenge = ->
  number = Math.floor(Math.random() * 10)

  question:
    start: number
  answer:
    end: number

exports.challenge = challenge
