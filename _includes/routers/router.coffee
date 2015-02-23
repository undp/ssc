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

    viewState = params?.viewState

    if params.filterRef? # Try to find from stores (local and remote)
      options = 
        filterRef: params.filterRef
        facetName: facetName
        facetValue: facetValue

      app.projects.rebuildFilterState(options) 

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
    if @routesHit > 1 # User did not land directly on current page
      window.history.back()
    else
      @navigate '', trigger: true, replace: true
    return

