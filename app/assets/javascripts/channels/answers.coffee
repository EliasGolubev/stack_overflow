channelRemove = ->
  if (App.answer)
      App.cable.subscriptions.remove(App.answer)
      App.answer = null

createAnswerChannel = ->
  unless $("[data-question]").length == 0
    questionId = $("[data-question]").data().question
    App.answer = App.cable.subscriptions.create { channel: "AnswersChannel", question_number: questionId }, 
      connected: ->
        questionId = $("[data-question]").data().question
        @perform 'follow', question_id: questionId

      received: (data) ->
        switch data['method']
          when 'publish' then @publish_answer(data)

      publish_answer: (data) ->
        $('.answers').append(JST["templates/answer"]({
          answer: data['answer'], 
          attachments: data['attachments'], 
          rating: data['rating']
        }))
    
$(document).on("turbolinks:load", channelRemove)
$(document).on("turbolinks:load", createAnswerChannel)