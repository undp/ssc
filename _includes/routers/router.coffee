Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

    # Keep count of number of routes handled by your application
    @routesHit = 0
    Backbone.history.on 'route', (-> @routesHit++), @

  routes:
    ''                       : '_explorer'
    'project/:projectId'     : '_project'
    'admin'                  : 'admin'
    ':facetName/:facetValue' : '_explorer'
  
  back: ->
    if @routesHit > 1 # User did not land directly on current page
      window.history.back()
    else
      @navigate '', trigger: true, replace: true
    return

  # ROUTES
  _explorer: (facetName, facetValue) ->
    return @_rootRoute() unless app.filters.validFilters(facetName, facetValue)

    params = app.utils.getUrlParams()

    if params.stateRef? # Try to find from stores (local and remote)
      
      options = 
        stateRef: params.stateRef
        facetName: facetName
        facetValue: facetValue
        viewState: params?.viewState

      app.state.retrieveStateData(options) 

    else if facetName and facetValue
      app.projects._facetManager.clearFilters() # TODO: Check if clearFilters() needed
      app.projects._facetManager.addFilter(name: facetName, value: facetValue)

    else
      app.projects._facetManager.clearFilters()

    view = new ExplorerView(collection: app.projects)
    @_switchView(view)

  _project: (id) ->
    @view.remove() if @view
    project = app.projects.get(id)
    view = new ProjectView(model: project)
    @_switchView(view)

  # View management
  _rootRoute: ->
    @navigate '', trigger: true, replace: true

  _switchView: (view) ->
    @view.remove() if @view
    @view = view
    @view.render()
    @$appEl.html(@view.$el)

