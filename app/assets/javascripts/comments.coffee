$('.add-question-comments').click (e) ->
  e.preventDefault()
  console.log('Ok')
  comments = $('.question-comments-block')

  unless $(this).hasClass('cancel')
    $(this).html('Cancel')
    $(this).addClass('cancel')
    comments.show()
  else
    $(this).html('Show comments')
    $(this).removeClass('cancel')
    comments.hide()
  return undefined
