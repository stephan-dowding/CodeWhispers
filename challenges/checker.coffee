exports.check = (answer, response) ->
  matches = []
  matches.push answer[item] == response[item] for item of answer
  matches.reduce (a, b) -> a && b
