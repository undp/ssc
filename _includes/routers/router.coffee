Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

  routes:
    ''                       : 'renderExplorerFacet'
    'project/:projectId'     : 'project'
    'admin'                  : 'admin'
    ':facetName/:facetValue' : 'renderExplorerFacet'
  
  renderExplorerFacet: (facetName, facetValue) ->
    params = app.utils.getUrlParams()
    app.projects.clearFilters()

    if params.filterRef?
      app.projects.retrieveFiltersFromId(params.filterRef, facetName, facetValue) 
    else if facetName && facetValue
      app.projects.addFilter(facetName, facetValue)

    view = new ExplorerView(collection: app.projects)
    @switchView(view)

  project: (id) ->
    @view.remove() if @view
    project = app.projects.get(id)
    view = new ProjectView(model: project)
    @switchView(view)

  switchView: (view) ->
    @view.remove() if @view
    @view = view
    @view.render()
    @$appEl.html(@view.$el)


