window.gs = gs = window.gs || {}

gs.util =
  # show loading on search
  search: ->
    $("#search").css "background", "#ccc url(//d1grml7t1u9jas.cloudfront.net/img/loader/searchload.gif) 160px 5px no-repeat"
    true
