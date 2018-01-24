window.gs = gs = window.gs or {}

gs.map =

  # build an array of LatLngs from JSON data
  buildTrack: (points) ->
    for point in points
      console.log(point.lat,point.lng)
      new google.maps.LatLng(point.lat,point.lng)

  # build custom markers
  buildMarker: (color) ->
    new google.maps.MarkerImage(
      "//d1grml7t1u9jas.cloudfront.net/img/map/#{color}.png"
      new google.maps.Size(12, 20)
      new google.maps.Point(0, 0)
      new google.maps.Point(6, 22)
    )

  # build a polyline
  drawPolyline: (coords, color, opacity, weight) ->
    color = "#ff0000"  unless color
    opacity = 0.5  unless opacity
    weight = 6  unless weight
    new google.maps.Polyline(
      path: coords
      strokeColor: color
      strokeOpacity: opacity
      strokeWeight: weight
    ).setMap(@map)

  # helper function to build markers and infoboxes
  drawMarker: (config, zIndex) ->
    zIndex = zIndex||0;
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(config.lat, config.lng)
      map: @map
      icon: @marker[config.marker],
      zIndex: zIndex,
      shadow: @marker.shadow
      shape: @marker.shape
      data: config
    )
    # store location data
    @locations[config.id] = config
    # if this marker has an infowindow, add a listener to launch it
    if config.infowindow
      google.maps.event.addListener(
        marker
        'click'
        => @drawInfoWindow(marker)
      )

  # called when marker is clicked
  drawInfoWindow: (marker) ->
    # prepare blank infowindow
    infowindow = new google.maps.InfoWindow(
      content: '<div class="infowindow"><div class="mapload"></div>loading...</div>'
    )
    # close any open infowindows
    @info.close() if @info
    @info = infowindow
    # open clicked window
    @info.open(@map, marker)
    # if data has not yet been loaded, do it
    unless infowindow.loaded
      $.ajax
        type: "POST"
        url: "/infowindow"
        data: marker.data
        success: (response) =>
          @info.setContent(response)
          @info.loaded = true
          gs.photos.initEffects()

  # load maps api async
  init: (el, options) ->
    # save element to insert map into
    @el = el
    # assign options to be used when building map
    @options = options||{}

    # load google maps, callback to gs.map.init when ready
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyCuIy2sg0FV6hWvjXor7TEY1B0iJFqmKPc&sensor=true&callback=gs.map.onApiLoaded'
    document.body.appendChild(script)

  # called when google maps loads
  onApiLoaded: ->
    # configure default options and override if needed
    @options = $.extend(
      zoom: 3
      mapTypeId: google.maps.MapTypeId.ROADMAP
      scrollwheel: false
      scaleControl: true
      center: new google.maps.LatLng(45, 57),
      marginTop: 45
    , @options)

    # set height from top
    @el.css('marginTop',@options.marginTop);

    # build custom markers
    @marker =
      red: @buildMarker('red')
      orange: @buildMarker('orange')
      yellow: @buildMarker('yellow')
      green: @buildMarker('green')
      blue: @buildMarker('blue')
      shadow: new google.maps.MarkerImage(
        '//d1grml7t1u9jas.cloudfront.net/img/map/marker-shadow.png'
        new google.maps.Size(22, 20)
        new google.maps.Point(0, 0)
        new google.maps.Point(6, 22)
      )
      shape:
        coord: [1, 1, 1, 20, 18, 20, 18, 1]
        type: 'poly'
    # initialize array to hold location data
    @locations = []
    # initialize map with defined options
    @map = new google.maps.Map(@el.get(0), @options)
    # run callback for map completed loading
    @afterLoad() if $.isFunction(@afterLoad)

  # enable map full screen mode
  fullscreen: ->
    $(window).resize(=>
      h = $(window).height()
      w = $(window).width()
      if h != @h || w != @w
        @el.css('height', h-@options.marginTop)
        @el.css('width', w)
        @h = h-@options.marginTop
        @w = w
        google.maps.event.trigger(@map, 'resize')
    ).trigger('resize')

  # zoom to a point stored in this.locations
  zoomTo: (id, zoom) ->
    if loc = @locations[id]
      @map.setCenter(new google.maps.LatLng(loc.lat, loc.lng))
      @map.setZoom(zoom||15)

  # load a track and draw it on the map
  loadTrack: (track_id, location_id) ->
    $.ajax
      type: 'POST'
      url: '/track'
      dataType: 'json'
      data: {id: track_id}
      success: (response) =>
        track = @buildTrack(response)
        @drawPolyline(track)
        @zoomTo(location_id, 10)
