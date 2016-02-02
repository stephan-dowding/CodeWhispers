$ ->
  table = $('.branches')
  currentRound = null
  teams = []

  getDetails = ->
    $.getJSON '/details', (data) ->
      teams = data.branches
      updateInstructions(data.round)
      rebuildTable()

  rebuildTable = ->
    table.children().remove()

    header = $("<tr>")
    header.append "<th>Teams</th>"

    for i in [0..currentRound]
      header.append "<th id='header-#{i}'>#{i}</th>"

    table.append header


    for team in teams
      addTeam(team)

  addTeam = (item) ->
    row = $("<tr id='team-#{item.name}'>")
    row.append "<td>#{item.name}</td>"
    for i in [0..currentRound]
      value = if item[i] then "tick" else "cross"
      row.append "<td id='info-#{item.name}-#{i}'><img id='status-#{item.name}-#{i}' src='/assets/#{value}.png' height='25' width='25' /></td>"
    table.append row

  updateInstructions = (roundNumber) ->
    if currentRound != roundNumber
      currentRound = roundNumber
      $('.roundNumber').text currentRound
      $.get '/question', (data) ->
        instructions = $('.instructions')
        instructions.children().remove()
        instructions.append(data)


  roundSocket = io.connect '/round'
  roundSocket.on 'new round', (roundNumber) ->
    updateInstructions(roundNumber)
    rebuildTable()

  getDetails()

  teamSocket = io.connect '/teams'
  teamSocket.on 'new team', (teamName) ->
    stop = false;
    for team in teams
      if team.name == teamName
        stop = true

    if !stop
      newTeam = {name: teamName}
      teams.push newTeam
      addTeam(newTeam)
  teamSocket.on 'remove team', (teamName) ->
    index = null
    for i in [0..teams.length-1]
      if teams[i].name == teamName
        index = i
    teams.splice(index, 1) if index
    $("#team-#{teamName}").remove()
