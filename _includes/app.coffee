$(document).ready ->
  # Collections
  app.projects = new Projects
  app.filters = new Filters
  app.projects.fetch(
    ajaxSync: true
    reset: true
    success: (data) =>
      app.projects.each((i) -> i.save())
      app.launch(app.projects)
  )


app.launch = (collection) ->
  app.state = new StateModel({}, collection: collection)
  app.router = new Router()
  Backbone.history.start()
