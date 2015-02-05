app.utils = {}

app.utils.capitaliseFirstLetter = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

app.utils.resizeIframe = (id) ->
    if document.getElementById 
      newheight=document.getElementById(id).contentWindow.document.body.scrollHeight
      newwidth=document.getElementById(id).contentWindow.document.body.scrollWidth
      document.getElementById(id).height= (newheight) + "px"
      document.getElementById(id).width= (newwidth) + "px"

