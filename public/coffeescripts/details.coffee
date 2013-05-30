getDetails = ->
  $.getJSON '/details', (data) ->
    list = $('.branches')
    list.children().remove()
    for item in data.branches
      list.append "<li>#{item}</li>"
    $('.roundNumber').text data.round

$ ->
  getDetails()
  setInterval getDetails, 5000
