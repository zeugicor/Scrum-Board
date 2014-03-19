$ ->
  #
  # Globale Formularvalidierung
  # ----------------------------------------------------------------
  $('form').validate(
    errorElement:     'span'
    errorClass:       'help-block'
    focusInvalid:     false

    rules:
      email:
        email: true

    highlight: (element) ->
      $(element).closest('.form-group').addClass('has-error')

    unhighlight: (element) ->
      $(element).closest('.form-group').removeClass('has-error')

    errorPlacement: (error, element) ->
      if element.parent('.input-group').size() > 0
        error.insertAfter element.parent('.input-group')
      else
        error.insertAfter element
  )

  # Formular nach Select2 Change erneut validieren
  form = $('form')
  $('select', form).change ->
    form.validate(element($(this)))