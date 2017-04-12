App.product = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    @perform 'follow'

  received: (data) ->
    console.log(data)
    $('.questions-list').append(data)
