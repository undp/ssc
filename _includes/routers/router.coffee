Router = Backbone.Router.extend
  routes:
    "": "root"
  
  # As good a place as any to start
  root: ->
    window.projects = new Projects(ssc_data)
    # TODO: Any point in deleting?
    # delete window.ssc_data 
    # TODO: Could replace initialisation in index.html
    @view = new app.views.App(collection: projects)

