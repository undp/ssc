Router = Backbone.Router.extend
  routes:
    "": "root"
    "location/:iso3": "byLocation"
  
  root: ->
    @view = new app.views.App(collection: window.projects)

  byLocation: (iso3) ->
    console.log "Projects for #{iso3}"
    window.location_projects = new Projects(
      window.projects.filter (i) ->
        _.include(i.get('host_location'), iso3.toUpperCase())
    )
    @view = new app.views.App(collection: location_projects)
