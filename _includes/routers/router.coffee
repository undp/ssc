Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")
    @routesHit = 0
    # keep count of number of routes handled by your application
    Backbone.history.on 'route', (-> @routesHit++), @

  routes:
    ''                       : 'explorer'
    'project/:projectId'     : 'project'
    'admin'                  : 'admin'
    ':facetName/:facetValue' : 'explorer'
  
  # ROUTES
  explorer: (facetName, facetValue) ->
    params = app.utils.getUrlParams()

    console.log 'clearFilters here or not always?'
    # app.projects.clearFilters()

    if params.filterRef? # Try to find from stores (local and remote)
      options = 
        filterRef: params.filterRef
        facetName: facetName
        facetValue: facetValue

      app.projects.recreateFilterStateFromRef(options) 

    else if facetName and facetValue
      app.projects.clearFilters() # Better in here?
      app.projects.addFilter(name: facetName, value: facetValue)

    view = new ExplorerView(collection: app.projects)
    @switchView(view)

  project: (id) ->
    @view.remove() if @view
    project = app.projects.get(id)
    view = new ProjectView(model: project)
    @switchView(view)

  # View management
  switchView: (view) ->
    @view.remove() if @view
    @view = view
    @view.render()
    @$appEl.html(@view.$el)


  back: ->
    if @routesHit > 1
      # more than one route hit -> user did not land to current page directly
      window.history.back()
    else
      # otherwise go to the home page. Use replaceState if available so
      #the navigation doesn't create an extra history entry
      @navigate '',
        trigger: true
        replace: true
    return

