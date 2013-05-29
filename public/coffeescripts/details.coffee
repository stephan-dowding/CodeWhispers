getDetails = ->
  $.getJSON '/details', (data) ->
    list = $('.branches')
    list.children().remove()
    for item in data.branches
      list.append "<li>#{item}</li>"

$ ->
  getDetails()
  setInterval getDetails, 5000
