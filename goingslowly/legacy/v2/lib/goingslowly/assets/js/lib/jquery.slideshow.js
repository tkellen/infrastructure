(function($)
{
  $.slideshow = function(el, settings)
  {
     var base = this;

     base.el = $(el); // shorthand to called element
     base.el.data("slideshow",base);  // allow entry from dom

     var state =
     {
       pos: 0,
       total: 0,
       running: false,
       paused: false,
       thumbHTML: [],
       zCount: 0
     };

     // initialize slideshow
     base.init = function()
     {
       base.settings = $.extend({},$.slideshow.settings,settings);
       var s = base.settings;

       // process slides
       base.slides = base.el.children('a');
       base.slides.each(function(i)
       {
         var s = base.settings;

         var slide = $(this);
         var image = $(this).find('img:first');
         var url = image.attr(s.srcAttribute);

         image.remove();
         slide.css(
         {
           background:'#111 url("'+url+'") no-repeat',
           zIndex:0
         });

         if(s.thumbnails)
         {
           url = url.replace(s.thumbSearch,s.thumbReplace);
           state.thumbHTML.push('<span style="background-image:url('+url+')"/>');
         }
         state.total++;
       });

       // wrap slideshow for mat effect
       var mat = $('<div class="slide-mat '+s.wrapClass+'"></div>');
       base.el.wrap(mat);

       // wrap slideshow to hold all elements
       var wrap = $('<div class="slide-wrap"></div>');
       base.el.parent().wrap(wrap);
       base.el.parent().parent().hover(base.over,base.out);


       // add previous button
       var prev = $('<div class="slide-prev"></div>');
       prev.click(base.prev);
       base.el.after(prev);

       // prevent selecting
       prev.bind("dragstart selectstart",function(e){e.preventDefault();return false;});

       // add next button
       var next = $('<div class="slide-next"></div>');
       next.click(base.next);
       base.el.after(next);

       // prevent selecting
       next.bind("dragstart selectstart",function(e){e.preventDefault();return false;});

       // add thumb bar
       if(s.thumbnails)
       {
         var thumbcontainer = $('<div class="slide-thumbs '+s.thumbClass+'"></div>');
         var thumbnails = $(state.thumbHTML.join(''));
         thumbcontainer.append(thumbnails);
         base.el.parent().after(thumbcontainer);
         state.thumbbar =  base.el.parent().next();
         state.thumbbar.children().click(base.display);
         state.thumbbar.children().eq(0).addClass('active');
       }

       // show first image
       state.pos = state.total;
       base.display(0);

       $(window).load(function()
       {
         setInterval(function()
         {
           if(base.el.is(':inview') && !state.paused) base.next();
         },s.pauseTime);
       });
     };


     // start hovering
     base.over = function(){state.paused = true;};

     // stop hovering
     base.out = function(){state.paused = false;};

     // go to next image
     base.next = function()
     {
       var s = base.settings;
       var next = state.pos+1;
       if(next == state.total) next = 0;
       base.display(next);
     };

     // go to previous image
     base.prev = function()
     {
       var prev = state.pos-1;
       if(prev < 0) prev = state.total-1;
       base.display(prev);
     };

     // display photo
     base.display = function(show)
     {
       var s = base.settings;
       if(typeof(show) == 'object') show = $(this).index();
       var hide = state.pos;

       if(state.running || show == hide) return;
       state.running = true;

       base.slides.eq(show).hide().css('zIndex',++state.zCount);
       base.slides.eq(show).fadeIn(s.duration,function()
       {
         state.running = false;
         state.pos=show;
       });
       if(s.thumbnails) base.highlight(show);

     };

     // highlight thumbnail
     base.highlight = function(idx)
     {
       $('.active',state.thumbbar).removeClass('active');
       state.thumbbar.children().eq(idx).addClass('active');
     };

     base.init();
  };
  $.fn.slideshow = function(s){return this.each(function(){(new $.slideshow(this,s));});};

  $.slideshow.settings =
  {
    width: 788,
    height: 522,
    duration:500,
    pauseTime:5000,
    srcAttribute:'src',
    wrapClass: 'mask',
    thumbClass: 'mask',
    thumbnails:true,
    thumbSearch:'normal',
    thumbReplace:'thumbnail',
    thumbHeight:false,
    thumbWidth:false,
    process:function(slide){}
  };
})(jQuery);
