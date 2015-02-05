app.utils = {}

app.utils.capitaliseFirstLetter = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

app.utils.resizeIframe = (id) ->
  _.delay ->
    if document.getElementById(id)
      newheight = document.getElementById(id).contentWindow.document.body.scrollHeight
      document.getElementById(id).height= (newheight) + "px"
  , 500
