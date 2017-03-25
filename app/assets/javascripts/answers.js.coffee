eadit_answer = ->
    $(".edit-answer-link").click (e)->
      e.preventDefault()
      $(this).hide();
      answer_id = $(this).data('answerId')
      $("#edit_answer_#{answer_id}").show()
      return undefined
    return undefined

$(document).ready(eadit_answer)
$(document).on('page:load', eadit_answer)
$(document).on("turbolinks:load", eadit_answer)
$(document).on('page:update', eadit_answer)
