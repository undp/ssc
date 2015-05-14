app.utils = {}

# Create probably unique IDs
app.utils.PUID = ->
  @s4() + @s4() + @s4()

app.utils.validPUID = (uuid) ->
  regex = /.{12}/
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

app.utils.generateEditingUrl = (id) ->
  "http://prose.io/##{app.config.repo}/edit/gh-pages/_ssc_projects/#{id}.txt"  

app.utils.newProjectId = ->
  "xxx" + Math.floor(Math.random()*4294967295).toString(16)

# Make sure 'console' doesn't throw errors in IE
do ->
  noop = ->

  methods = ['assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error', 'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log', 'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd', 'timeline', 'timelineEnd', 'timeStamp', 'trace', 'warn']
  length = methods.length
  console = window.console = window.console or {}
  while length--
    method = methods[length]
    # Only stub undefined methods.
    console[method] = noop if !console[method]
