$ ->
  $('#nextRound').click ->
    $.post('/action/next-round').done (data)->
      $('#round').text("Round #{data.round}")
      $('#swapping').children().remove()
      table = $ '<table>'
      header = $ '<tr>'
      header.append '<th>Origin</th>'
      header.append '<th>Destination</th>'
      table.append header
      for movement in data.mapping
        row = $ '<tr>'
        row.append "<th>#{movement.origin}</th>"
        row.append "<th>#{movement.destination}</th>"
        table.append row
      $('#swapping').append table
