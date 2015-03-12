Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

    # Keep count of number of routes handled by your application
    @routesHit = 0
    Backbone.history.on 'route', (-> @routesHit++), @

  routes:
    ''                       : '_explorer'
    'admin'                  : '_admin'
    ':action/:value' : '_explorer'
  
  back: ->
    if @routesHit > 1 # User did not land directly on current page
      window.history.back()
    else
      @navigate '', trigger: true, replace: true
    return

  # ROUTES
  _explorer: (action, value) ->
    return @_project(value) if action == 'project'
    return @_rootRoute() unless app.filters.validFilters(action, value)

    params = app.utils.getUrlParams()

    if params.stateRef? # Try to find State from stores (local and remote)
      options = 
        facetName: facetName
        facetValue: facetValue
        stateRef: params.stateRef
        viewState: params.viewState

      app.state.retrieveStateData(options) 

    else if facetName and facetValue # Use given primary facet name and value
      app.projects.clearFilters()
      app.projects.addFilter(name: facetName, value: facetValue)

    else # Start from scratch
      app.projects.clearFilters()

    view = new ExplorerView(collection: app.projects)
    @_switchView(view)

  _project: (id) ->
    project = app.projects.get(id)
    view = new ProjectView(model: project)
    @_switchView(view)

  _admin: ->
    console.log 'admin'

  # View management
  _rootRoute: ->
    @navigate '', trigger: true, replace: true

  _switchView: (newView) ->
    @view.remove() if @view
    @view = newView
    @view.render()
    @$appEl.html(@view.$el)

