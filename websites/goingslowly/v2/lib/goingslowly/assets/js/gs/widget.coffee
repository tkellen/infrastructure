window.gs = gs = window.gs || {}

gs.widget =

  state: {}

  # load widget into state
  load: (name, widget) ->
    if !@state[name]
      @state[name] = widget
      # run one-time setup function
      widget.setup()
    # execute every time widget is loaded
    widget.run()

  cleanup: ->
    for widget of @state
      if $.isFunction(@state[widget].teardown)
        @state[widget].teardown()
