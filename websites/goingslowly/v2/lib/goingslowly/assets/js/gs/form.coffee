window.gs = gs = window.gs || {}

gs.form =

  handler: (form, data) ->
    $(form).find(".error").removeClass "error"
    $(form).find(".errormsg").remove()
    if data.errors
      $.each data.errors, (i) ->
        $("#" + i).addClass("error").after "<div class=\"errormsg\">&uarr; " + data.errors[i].join(", ") + ".</div>"
      humane.error data.error_message
    else
      if data.thankyou
        $(form).slideUp "normal", ->
          $(form).after data.thankyou
      window.location.href = data.redirect if data.redirect

  init: (form) ->
    # remove form error notices on focus
    $(form).find("input,select,textarea").bind "focus click", ->
      if $(this).hasClass("error")
        $(this).next().slideUp "fast", ->
          $(this).remove()

        $(this).removeClass "error"

    # clear error on recaptcha
    $('#recaptcha').bind('focus click', -> $('.errormsg').slideUp())

    # override submit functionality
    $(form).submit ->
      buttontext = undefined
      submit = undefined
      submit = $(this).find("input[type=submit]")
      buttontext = submit.val()
      $(this).ajaxSubmit
        dataType: "json"
        beforeSubmit: (data, form, options) ->
          submit.val("Processing...").attr("disabled", true)

        success: (data) ->
          gs.form.handler form, data
          setTimeout (->
            submit.val(buttontext).attr("disabled", false)
          ), 100
          Recaptcha.reload() if window.Recaptcha

        error: ->
          humane.error "An unknown error occured.  Sorry about that :("
          setTimeout (->
            submit.val(buttontext).attr("disabled", false)
          ), 100
          Recaptcha.reload() if window.Recaptcha

      false
