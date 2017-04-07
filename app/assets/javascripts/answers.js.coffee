eadit_answer = ->
    $(".edit-answer-link").click (e)->
      e.preventDefault()
      $(this).hide();
      answer_id = $(this).data('answerId')
      $("#edit_answer_#{answer_id}").show()
      return undefined
    return undefined

new_answer_success = (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answer-errors').removeClass('alert alert-info').html('')
    $('textarea.form-control#answer_body').val('')
    $('.answers').append(answer.body)
    return undefined

new_answer_errors = (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
        $('.answer-errors').addClass('alert alert-info').append(value)
    return undefined

$(document).ready(eadit_answer)
$(document).on('page:load', eadit_answer)
$(document).on("turbolinks:load", eadit_answer)
$(document).on('page:update', eadit_answer)

#$(document).on 'ajax:success', 'form.new_answer', new_answer_success
#$(document).on 'ajax:error', 'form.new_answer', new_answer_errors