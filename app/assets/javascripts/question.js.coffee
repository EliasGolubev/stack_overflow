edit_question = ->
    $(".edit-question-link").click (e)->
        e.preventDefault()
        $('.question-show').hide()
        $('.question-edit').show()

$(document).ready(edit_question)
$(document).on('page:load', edit_question)
$(document).on("turbolinks:load", edit_question)
$(document).on('page:update', edit_question)
