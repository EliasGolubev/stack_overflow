question_rating_vote = (e) ->
  $('.question-vote-action').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    $('.question_rating_errors').removeClass('alert alert-info').html('')
    $('.question_rating_vote').html(vote.rating)
    return undefined

  $('.question-vote-action').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.question_rating_errors').html('')
    $('.question_rating_errors').addClass('alert alert-info').append(errors.message)
    return undefined
  return undefined

answer_rating_vote = (e) ->
  $('.answer-vote-action').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    $("#answer-#{vote.id}-rating-errors").removeClass('alert alert-info').html('')
    $("#answer-#{vote.id}-rating").html(vote.rating)
    return undefined

  $('.answer-vote-action').bind 'ajax:error', (e, xhr, status, error) ->
    vote = $.parseJSON(xhr.responseText)
    $("#answer-#{vote.id}-rating-errors").html('')
    $("#answer-#{vote.id}-rating-errors").addClass('alert alert-info').append(vote.message)
    return undefined
  return undefined

$(document).on 'click', '.question-vote-action', question_rating_vote
$(document).on 'click', '.answer-vote-action', answer_rating_vote
