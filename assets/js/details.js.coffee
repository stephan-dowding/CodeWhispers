currentRound = -1

getDetails = ->
  $.getJSON '/details', (data) ->
    table = $('.branches')
    table.children().remove()

    header = $("<tr>")
    header.append "<th>Teams</th>"

    for i in [0..data.round]
      header.append "<th>#{i}</th>"

    table.append header

    for item in data.branches
      row = $("<tr>")
      row.append "<td>#{item.name}</td>"
      for i in [0..data.round]
        value = if item[i] then "tick" else "cross"
        row.append "<td><img src='/assets/#{value}.png' height='25' width='25' /></td>"
      table.append row

updateInstructions = (roundNumber) ->
  if currentRound != roundNumber
    currentRound = roundNumber
    $('.roundNumber').text currentRound
    $.get '/question', (data) ->
      instructions = $('.instructions')
      instructions.children().remove()
      instructions.append(data)

$ ->
  roundSocket = io.connect '/round'
  roundSocket.on 'new round', (roundNumber) ->
    updateInstructions(roundNumber)

  getDetails()
  setInterval getDetails, 500
