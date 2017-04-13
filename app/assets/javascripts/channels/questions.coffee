App.question = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    @perform 'follow'

  received: (data) ->
    $('.questions-list').append(data)
