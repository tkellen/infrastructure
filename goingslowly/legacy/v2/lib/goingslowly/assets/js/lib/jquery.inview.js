// in view jQuery extension
$.extend($.expr[':'], {
  inview:function(e)
  {
    var wh = $(window).height();
    var st = $(document).scrollTop();
    var $el = $(e);
    var t = $el.offset().top;
    var h = $el.height();
    return (t+h>st&&t<st+wh);
  }
});