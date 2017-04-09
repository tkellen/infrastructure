window.gs = gs = window.gs || {}

gs.bookmark =

  # init bookmark state
  state: (if $.cookie('bookmarks') then $.cookie('bookmarks').split(',') else [])

  # enable ribbon / cache bookmark element
  init: ->
    @el = $('#bookmark').mouseout((->$(this).removeClass('justMarked justUnmarked')))
    @el.click((=>@toggle()))

  # set up bookmark for a specifed page
  initEntry: (id) ->
    if $.inArray(String(id), @state) != -1
      @ribbonDown().removeClass('justUnmarked justMarked')

  # save to cookie
  save: ->
    $.cookie('bookmarks', @state.join(','), {expires: 99999, path: '/'})

  # bookmark entry
  toggle: ->
    # get current journal id
    id = String(gs.journal.state.id)
    # check for bookmark presence
    idx = $.inArray(id, @state)
    # already bookmarked, remove
    if idx != -1
      @state.splice(idx,1)
      @save()
      @ribbonUp()
    else
      # not bookmarked, add it
      @state.push(id)
      @save()
      @ribbonDown()

  ribbonDown: ->
    @el.tipTip(
      defaultPosition: 'left'
      content: '<strong class="color">Remove bookmark.</strong>'
    ).addClass('bookmarked justMarked')

  ribbonUp: ->
    @el.tipTip(
      defaultPosition: 'left'
      content: '<strong class="color">Bookmark this entry!</strong>'
    ).removeClass('bookmarked').addClass('justUnmarked')




