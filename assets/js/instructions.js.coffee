$ ->
  updateInstructions = (roundNumber) ->
    $('.roundNumber').text roundNumber
    $.get "/question/#{roundNumber}", (data) ->
      instructions = $('.instructions')
      instructions.children().remove()
      instructions.append(data)

  roundSocket = io.connect '/round'
  roundSocket.on 'new round', (roundNumber) ->
    updateInstructions(roundNumber)
