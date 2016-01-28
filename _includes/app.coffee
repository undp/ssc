$(document).ready ->
  # Collections
  app.projects = new Projects
  app.filters = new Filters
  app.checkCachedDataAndLaunch()

# TODO: @refactor to Projects collection
app.checkCachedDataAndLaunch = ->  # Check whether cached data is up-to-date
  updated_at = preloadData.updated_at # Last projects data update date
  cached_updated_at = localStorage.getItem('updated_at')

  if Date.parse(cached_updated_at) >= Date.parse(updated_at)
    # No updated data available
    console.info('Local launch')
    localLaunch(updated_at)
  else
    # Updated data available. Force retrieve from remote
    console.info 'Updating cached Projects data'
    remoteLaunch(updated_at)


# Launch trying localStorage first
localLaunch = (updated_at) ->
  app.projects.fetch
    reset: true
    success: (collection) ->
      if collection.length == 0 # i.e. nothing in localStorage
        remoteLaunch(updated_at)
      else
        app.launch(app.projects)

# Launch forcing remote refresh
remoteLaunch = (updated_at) ->
  app.projects.fetch(
    ajaxSync: true
    reset: true
    success: (data) =>
      app.projects.each((i) -> i.save())
      localStorage.setItem('updated_at', updated_at)
      app.launch(app.projects)
  )


app.launch = (collection) ->
  app.state = new StateModel({}, collection: collection)
  app.router = new Router()
  Backbone.history.start()
