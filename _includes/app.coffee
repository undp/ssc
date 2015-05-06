$(document).ready ->
  # Collections
  app.projects = new Projects
  app.filters = new Filters

  app.projects.fetch
    reset: true
    success: (collection) ->
      app.state = new StateModel({}, collection: collection)
      app.router = new Router()
      Backbone.history.start()
