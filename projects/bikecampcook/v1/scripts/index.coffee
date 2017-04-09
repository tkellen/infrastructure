define (require) ->

  $ = jQuery = require('jquery')
  queryString = require('query_string')
  require('waypoints_sticky')
  require('scrollto')
  require('placeholder')
  require('forms')
  require('modernizr')
  require('numeric')
  VALID_CODES = ['btp', 'ablondeau', 'tt', 'taj', 'nha', 'ta', 'pf', 'jl']

  $ ->

    from = queryString.parse(location.search).from;
    isAffiliate = VALID_CODES.indexOf(from) != -1

    # flag external links to open in a new window
    $(document).on "click", "a[rel=external]", (e) ->
      window.open @href
      e.preventDefault()

    $('.paypal').on "submit", (e) ->
      e.preventDefault()

      itemNumber = $(e.target).find("input[name=item_number]")
      if isAffiliate and itemNumber.val().slice(-from.length) != from
        itemNumber.val("#{itemNumber.val()}-#{from}")

      form = $(e.target)
      amount = form.find('input[name=amount]').val()
      min_amount = form.find('input[name=min_amount]').val()
      if isNaN(amount) || amount < min_amount
        alert('Please enter a valid amount.')
      else
        @submit()

    $('.paypal input[name=amount]').numerical
      alpha: false
      decimal: true

    # make navbar stick to top of page after scroll
    $('nav').waypoint('sticky');

    # make anchor links scroll nicely
    $('a.scroll').click (e) ->
      href = this.href.split('#')[1];
      $.scrollTo('#'+href,{duration:200});
      e.preventDefault()

     # ajaxify contact form
    $('#contact form').submit ->
        submit = $(this).find('input[type=submit]')
        buttontext = submit.val()
        $(this).ajaxSubmit
          dataType: 'json'
          beforeSubmit: ->
            submit.val('Processing...').attr('disabled',true)
          success: ->
            setTimeout((->
              submit.val(buttontext).attr('disabled',false)
              $('#contact form').slideUp 200, ->
                $('#contact .container').append("<h3 style='color:#fff;text-align:center'>Thanks for your message&mdash;I'll get back to you as soon as I can!</h3>")
            ),100)
          error: ->
            alert('An unknown error occured.  Sorry about that :(')
        return false

    # ensure placeholders work on older browsers
    $('input, textarea').placeholder();

    # placeholders on inputs use fontawesome
    # this switches the font to the default when
    # their fields aren't empty
    $('.iconed').on 'keyup', ->
      input = $(@)
      if input.val().length == 0
          input.addClass('iconed');
      else
          input.removeClass('iconed');

    # add google map
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyCuIy2sg0FV6hWvjXor7TEY1B0iJFqmKPc&sensor=true&callback=mapLoaded'
    document.body.appendChild(script)

    window.mapLoaded = ->
      mapEl = $('#map').get(0)
      map = new google.maps.Map(mapEl, {
        zoom: 2
        mapTypeId: google.maps.MapTypeId.ROADMAP
        scrollwheel: false
        scaleControl: true
        center: new google.maps.LatLng(40, 40)
      })
      window.sightings.forEach (sighting) ->
        new google.maps.Marker(
          position: new google.maps.LatLng(sighting.lat, sighting.lng)
          map: map
        )
