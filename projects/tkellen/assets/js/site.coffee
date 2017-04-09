$ ->

  $("a[rel=external],.external").on "click", (e) ->
    window.open(this.href)
    e.preventDefault()

  SyntaxHighlighter.highlight()
  Hyphenator.run()