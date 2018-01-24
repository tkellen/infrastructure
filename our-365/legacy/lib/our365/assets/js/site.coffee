$(".fliplever").click ->
  $(this).closest(".panel").addClass "flip"

ds = ds or {}
ds.fileInputs = ->
  $this = $(this)
  $val = $this.val()
  valArray = $val.split("\\")
  newVal = valArray[valArray.length - 1]
  $button = $this.siblings(".button")
  $fakeFile = $this.siblings(".file-holder")
  if newVal isnt ""
    if $fakeFile.length is 0
      $button.after "<span class=\"file-holder\">" + newVal + "</span>"
    else
      $fakeFile.text newVal

$(document).ready ->

  # flag external links to open in a new window
  $("a[rel=external],.external").live "click", (e) ->
    window.open @href
    e.preventDefault()

  # hook into upload pane
  $(".file-wrapper input[type=file]").bind "change focus click", ds.fileInputs

  # init colorbox
  $('.submission').each ->
    self = $(this)
    self.find('img').tipTip()

    self.colorbox
      scalePhotos: true
      scrolling: false
      maxHeight: "95%"
      opacity: 0.95
      transition: "elastic"
      title: "<span class=\"color\">#{self.attr('title')}</span> &raquo; "+
             "<a href=\"#{self.data('link')}\" rel=\"external\">open original</a>"
