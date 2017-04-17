App.question = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    console.log("Connected question channel")
    @perform 'follow'

  received: (data) ->
    console.log(data['method'])
    switch(data['method'])
      when 'publish' then $('.questions-list').append(data['render'])
      when 'destroy' then $("#question-id-#{data['question_id']}").html('')
