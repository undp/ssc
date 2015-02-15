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
      app.projects.restoreFilterStateFromId(params.filterRef, facetName, facetValue) 
    else if facetName && facetValue
      app.projects.addFilter(name: facetName, value: facetValue)

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

  updateUrlForState: (facetName, facetValue, filterRef) ->
    url = ""
    url = "#{facetName}/#{facetValue}" if facetName? and facetValue?
    url += "?filterRef=#{filterRef}" if filterRef?
    app.router.navigate(url)
