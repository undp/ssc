Router = Backbone.Router.extend
  routes:
    "": "root"
  
  # As a place as any to start
  root: ->
    window.projects = new Projects(ssc_data)
    @view = new app.views.App(collection: projects)

