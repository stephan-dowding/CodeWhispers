randomise = (list) ->
  list = list.slice 0
  for i in [0...list.length-1]
    j = random(i+1, list.length)
    [list[i], list[j]] = [list[j], list[i]]
  list

random = (min, max) ->
  min + Math.floor(Math.random() * (max - min))

exports.randomise = randomise
