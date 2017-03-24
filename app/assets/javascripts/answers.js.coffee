ready = ->
    $(".edit-answer-link").click (e)->
      e.preventDefault()
      $(this).hide();
      answer_id = $(this).data('answerId')
      $("#edit_answer_#{answer_id}").show()
      return undefined
    return undefined

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on("turbolinks:load", ready)
$(document).on('page:update', ready)
