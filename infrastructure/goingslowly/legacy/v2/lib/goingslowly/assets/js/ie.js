$(function() {
  if($.browser.msie && parseInt($.browser.version) < 8) {
    $('#rnext,#lnext').html('&raquo;');
    $('#rprev,#lprev').html('&laquo;');
    $('.mask img').after('<div class="clear"></div>');
    $('.slide-thumbs').append('<div class="clear" style="height:0px;"></div>')
                      .css('overflow','visible');
    $('.dropcap').removeClass('dropcap');
  }
  $('hr').wrapAll('<div class="hr"></div>');
  $('#about,#recents').css('left','-840px');
});
