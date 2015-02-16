app.utils = {}

app.utils.UUID = ->
  @s4() + @s4() + '-' + @s4() + '-' + @s4() + '-' + @s4() + '-' + @s4() + @s4() + @s4()

app.utils.validUUID = (uuid) ->
  regex = /.{8}\-.{4}\-.{4}\-.{4}\-.{12}/
  regex.test uuid

app.utils.s4 = ->
  Math.floor((1 + Math.random()) * 0x10000) .toString(16) .substring(1)

app.utils.getUrlParams = ->
  hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&')
  _.object(
    _.map(hashes, (rawHash) ->
      hash = rawHash.split('=')
      [hash[0], hash[1]]
    ) 
  )
