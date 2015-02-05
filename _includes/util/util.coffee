app.utils = {}

app.utils.capitaliseFirstLetter = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

app.utils.resizeIframe = (id) ->
  _.delay ->
    if doc = document.getElementById(id)
      newheight = doc.contentWindow.document.body.scrollHeight
      doc.height= (newheight) + "px"
      $('#contentTruncated').hide()
  , 500
