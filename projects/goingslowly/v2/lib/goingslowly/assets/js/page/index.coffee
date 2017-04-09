$ ->

  # embedding soundcloud in bxSlider for IE8 or lower mucks things up, how annoying
  if not $.browser.msie or ($.browser.msie and $.browser.version > 8)
    $("#soundcloud").html "<object height=\"282\" width=\"100%\"> <param name=\"movie\" value=\"http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Fplaylists%2F92329&amp;show_comments=true&amp;auto_play=false&amp;show_playcount=true&amp;show_artwork=true&amp;color=ff7700\"></param> <param name=\"allowscriptaccess\" value=\"always\"></param> <param name=\"wmode\" value=\"transparent\"></param><embed wmode=\"window\" allowscriptaccess=\"always\" height=\"282\" src=\"http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Fplaylists%2F92329&amp;show_comments=true&amp;auto_play=false&amp;show_playcount=true&amp;show_artwork=true&amp;color=ff7700\" type=\"application/x-shockwave-flash\" width=\"100%\"></embed></object></div>"
  else
    $("#soundcloud").html "<h3 style=\"padding-top:40px\">This section does not work in Internet Explorer 8.0 or lower.</h3><p><strong>Please</strong> consider <a href=\"http://windows.microsoft.com/en-US/internet-explorer/products/ie/home\" rel=\"external\">upgrading to Internet Explorer 9</a>.</p><p>If you are running Windows XP, switching to <a href=\"http://chrome.google.com/\" rel=\"external\">Google Chrome</a> or <a href=\"http://www.firefox.com\" rel=\"external\">Mozilla Firefox</a> are both excellent choices that will greatly increase the speed and quality of your browsing!"

  $("#tweets").tweet
    username: "goingslowly"
    join_text: "auto"
    avatar_size: 34
    count: 6
    auto_join_text_default: "we said,"
    auto_join_text_ed: "we"
    auto_join_text_ing: "we were"
    auto_join_text_reply: "we replied to"
    auto_join_text_url: "we were checking out"
    loading_text: "loading tweets..."

  slider =
    controls: true
    auto: false
    autoHover: true
    pause: 6000
    pager: true

  $("#about").bxSlider(slider)
  $("#recents").bxSlider(slider)

  gs.photos.initEffects()