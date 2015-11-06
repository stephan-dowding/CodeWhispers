exports.calculatePath = (instructions, startingCoordinate) ->
  instructions.reduce ((path,instruction) ->
    [..., prev] = path
    if (instruction == 'L') then path.push([prev[0], prev[1] + 1])
    else if (instruction == 'R') then path.push([prev[0], prev[1] - 1])
    else if (instruction == 'F') then path.push([prev[0] + 1, prev[1]])
    else path.push([prev[0] - 1, prev[1]])
    path)
    , [startingCoordinate]
