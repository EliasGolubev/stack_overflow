edit_answer = (e) ->
  e.preventDefault()
  $(this).hide()
  answer_id = $(this).data('answerId')
  $("#edit_answer_#{answer_id}").show()

$(document).on 'click', 'a.edit-answer-link', edit_answer
