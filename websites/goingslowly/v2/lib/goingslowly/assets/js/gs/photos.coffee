window.gs = gs = window.gs || {}

gs.photos =

  initEffects: (container) ->
    # use the entire page if no search node has been defined
    container = $('body') if !container
    # set up image hoverbox
    container.find("a.photo").attr("rel", "colorbox").each ->
      # save reference
      self = $(this)
      # set link to lightbox data attr
      self.attr("href", self.data("lightbox"))
      # add controls for hover
      if !self.hasClass('thumbnail') && !self.hasClass('notitle')
        self.prepend("<span class='title'>#{self.attr('title')}</span><span class='expand'></span>")
      # configure lightbox
      self.colorbox(
        scalePhotos: true
        scrolling: false
        maxHeight: "95%"
        transition: "elastic"
        title: "<span class=\"color\">#{@title}</span>"+
               " &raquo; "+
               "<a href=\"#{$(this).data("link")}\" rel=\"external\">"+
               "open in flick<strong style=\"color:#ff0084\">r</strong>"+
               "</a>"
      )
    # init slideshows
    container.find(".slideshow").each ->
      ss = $(this)
      ss.slideshow pauseTime: $(this).attr("speed") or 5000
