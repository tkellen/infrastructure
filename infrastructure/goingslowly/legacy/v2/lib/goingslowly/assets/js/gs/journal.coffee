window.gs = gs = window.gs || {}

gs.journal =

  loaded: false

  # keep track of which JS widgets have been enabled
  widgets: {}

  # run on initial load for journal
  init: ->

    if history.pushState
      window.onpopstate = (event) ->
        if event.state && event.state.real
          window.location.href = location.href

    # enable comments section if needed
    url = document.location.toString()
    if url.match('#')
      anchor = url.split('#')[1]
      comment_form() if anchor is 'postacomment'

    # initialize page flipper tooltips
    $('#lprev,#rprev,#lnext,#rnext,#infobox').removeAttr('title')

    # set up infobox tab
    $('#info').tipTip(
      defaultPosition: 'left'
      content: '<strong class="color">Mapping:</strong><br/>Click to view map for this day'
    ).removeAttr('title').click (e) ->
      gs.journal.infoBox($(this).attr('href'))
      e.preventDefault()

    # setup previous tabs
    $('#lprev,#rprev').click (e) ->
      gs.journal.navigateTo($(this).attr('href'), 'left')
      e.preventDefault()

    # setup next tabs
    $('#lnext,#rnext').click (e) ->
      gs.journal.navigateTo($(this).attr('href'), 'right')
      e.preventDefault()

    # check to see if control tabs should be visible
    $(window).scroll((->
      ch = parseInt($('#container').height())
      st = parseInt($(document).scrollTop())
      if ch < (st + 500)
        $('#left,#right,#time').fadeOut('fast')
      else
        $('#left,#right,#time').fadeIn('fast')
    )).trigger('scroll')

  # run after page has loaded via ajax
  initEntry: (state) ->
    @state = state
    # set page title
    $(document).attr('title', @state.title)
    # spool up navigation tabs
    @initTabs()
    # insert social stuff async
    @initSocial()
    # highlight text if needed
    @initHighlight()
    # flag loaded
    @loaded = true

  # configure journal flipper tabs
  initTabs: ->
    # only set time if request was loaded via ajax
    if @state.xhr
      time = $('#timecontent')
      time.fadeOut 'fast', =>
        time.html("#{@state.month}<div class='day'>#{@state.day}</div>#{@state.year}").fadeIn('fast')

    # set up map box
    $('#info').attr('href',"http://map.goingslowly.com#{@state.href}")

    # set up previous control tabs
    if !@state.prev
      setTimeout((->$('#lprev,#rprev').fadeOut('fast')), 1000)
    else
      tip = "<strong class='color'>Previous #{if @state.filedUnder then @state.filedUnder else ""} Entry:</strong><br/>#{@state.prev.title}"
      $('#lprev,#rprev').fadeIn('fast')
      $('#lprev').tipTip({defaultPosition: 'left', content: tip})
      $('#rprev').tipTip({defaultPosition: 'right', content: tip})
      $('#lprev,#rprev').attr('href',@state.prev.href)

    # set up next control tabs
    if !@state.next
      setTimeout((->$('#lnext,#rnext').fadeOut('fast')), 1000)
    else
      tip = "<strong class='color'>Next #{if @state.filedUnder then @state.filedUnder else ""} Entry:</strong><br/>#{@state.next.title}"
      $('#lnext,#rnext').fadeIn('fast')
      $('#lnext').tipTip({defaultPosition: 'left', content: tip})
      $('#rnext').tipTip({defaultPosition: 'right', content: tip})
      $('#lnext,#rnext').attr('href',@state.next.href)

  # add social networking links async
  initSocial: ->
    share = []
    share.push "<div id='share'>"
    share.push "<strong>Share this:</strong>"
    share.push "<a href='http://twitter.com/share' class='twitter-share-button' data-url='http://journal.goingslowly.com#{@state.href}' data-count='none' data-via='goingslowly'>Tweet</a><script src='http://platform.twitter.com/widgets.js'></script>"
    share.push "<div class='plusone'><div class='g-plusone' data-href=\'http://journal.goingslowly.com#{@state.href}' data-size='medium' data-count='false'></div></div><script src='https://apis.google.com/js/plusone.js'></script>"
    share.push "<iframe height='30' src='http://www.facebook.com/plugins/like.php?href=http://journal.goingslowly.com#{@state.href}&layout=button_standard&amp;show_faces=false&amp;width=450&amp;action=like&amp;colorscheme=dark&amp;height=25' scrolling='no' frameborder='0' class='facebook' allowTransparency='true'></iframe>"
    share.push "</div>"
    $('#meta').prepend(share.join(''))
    $('#share').fadeIn()

  # highlight search results
  initHighlight: ->
    if @state.highlight
      $('#search').val(@state.highlight)
      terms = @state.highlight.split(' ')
      for i of terms
        $('#journal .entry, .filedunder').highlight(terms[i])

  # clean up journal entry for page transition
  cleanup: ->
    # flag loaded as false until page is in
    @loaded = false
    # trigger mouseleave to hide tiptip elements
    $('#left a,#right a').trigger('mouseleave')
    # empty infobox
    $('#infobox').empty().hide()
    $(document).unbind('click')
    # clear bookmark
    gs.bookmark.ribbonUp();
    # unload widgets if needed
    gs.widget.cleanup();

  # load page
  navigateTo: (url, dir) ->
    # don't do anything if page hasn't finished loading
    return if !@loaded
    # if pushState isn't available, just change url
    if !history.pushState
      window.location.href = url
      return
    # prep journal for transition
    @cleanup()
    # push new url into history
    history.pushState({real: true}, null, url)
    # track analytics
    window._gaq.push ['_trackPageview', url] if window._gaq
    # are we throwing left or right?
    moveto = (if dir is 'left' then -881 else 881)
    # flag the page as loading
    $(document).attr('title', 'Loading...')
    # spinner image
    spinner = "<img style='margin-top:15px' src='//d1grml7t1u9jas.cloudfront.net/img/loader/pageload.gif'/>"
    # fly page out
    $('#journal').animate {marginLeft: moveto}, 250, ->
      $('body').animate({scrollTop:0},0)
      $('#timecontent').fadeOut 'fast', ->
        $(this).fadeOut 'fast', ->
          $(this).html(spinner).fadeIn 'fast', ->
            $.ajax
              type: 'GET',
              url: url+'?ajax',
              success: (data) ->
                $('#journal').html(data).css(marginLeft: (moveto * -1))
                             .animate({marginLeft: '0px'},250)

  # pop up mapping box (to be extended to do a lot more later)
  infoBox: (href) ->
    # if the infobox isnt visible already
    if !$('#infobox').is(':visible')
      # show it
      $('#infobox').fadeIn 'fast', ->
        # set clicks anywhere to close this
        $(document).bind 'click', ->
          $("#infobox").fadeOut()
          $(document).unbind 'click'
        # load map
        if !$('#infobox').html()
          $('#infobox').html("<iframe style=\"height:450px;width:100%\" src=\"#{href}?hidenav=true\"></iframe>")
    else
      $("#infobox").fadeOut()

  showCommentForm: ->

    # enable form ajax
    gs.form.init($("#commentform"))

    $("#comment-slide").slideDown "normal", ->
      if $('#recaptcha').html() == ""
        Recaptcha.create('6LfzVNgSAAAAAK6prNt161Cima1whf5VEOIlgQFj', 'recaptcha', {theme:'clean'});
      $.scrollTo "#commentform",
        offset: -100
        duration: 200
