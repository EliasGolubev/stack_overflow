channelCommentsRemove = ->
  if (App.comment)
      App.cable.subscriptions.remove(App.comment)
      App.comment = null

createCommentsChannel = ->
  unless $("[data-question]").length == 0
    questionId = $("[data-question]").data().question
    App.comment = App.cable.subscriptions.create { channel: "CommentsChannel", question_number: questionId },
    connected: ->
      console.log('Connected comments channel')
      questionId = $("[data-question]").data().question
      @perform 'follow', question_id: questionId
    
    received: (data) ->
      $('#comentable-'+data['comentable_id']).append(JST["templates/comments/comment"]({
          comment: data['comment']
        }))
    
    publish_comment: (data) ->
      console.log('Publish comments channel')

$(document).on("turbolinks:load", channelCommentsRemove)
$(document).on("turbolinks:load", createCommentsChannel)
