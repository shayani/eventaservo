$ ->
  $('.datepicker').datepicker
    dateFormat: 'dd/mm/yy'
    firstDay: 1
    $.datepicker.regional['eo']

  $('.datepicker').mask '00/00/0000', placeholder: "__/__/____"
  $('.birthday').mask '00/00/0000', placeholder: "Naskiĝdato (T/M/J) *ne deviga"
  $('.timemask').mask '00:00', placeholder: "__:__"
  $('.timemask').on 'focus click touchend', ->
    $(this)[0].setSelectionRange 0, 5

  $('[data-toggle="tooltip"]').tooltip()

  $('.select2-input').select2
    theme: 'bootstrap'
    language:
      noResults: ->
        'Neniu trafo'

  $('.js-smartPhoto').SmartPhoto()

  $('#search_form input').keyup (event)->
    if (event.which == 13)
      $(this).blur()
    else
      delay (->
        $.get $('#search_form').attr('action'), $('#search_form').serialize(), null, 'script'
      ), 500

  # Organiza serĉilo
  $('#o_search_form input').keyup (event)->
    delay (->
      $.get $('#o_search_form').attr('action'), $('#o_search_form').serialize(), null, 'script'
    ), 500
