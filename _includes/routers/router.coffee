Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

  routes:
    "": "redirect"
    "all": "all"
    "location/:location": "byLocation"
    "theme/:theme": "byTheme"
    "partner/:partner_type": "byPartner"
    "role/:undp_role": "byRole"
    "project/:id": "project"
    "search/:term": "search"
  
  redirect: ->
    @navigate 'all', trigger: true

  all: ->
    @renderExplorerFacet()

  byLocation: (param) ->
    if app.countries.nameFromIso(param)
      facetName = 'host_location'
      param = param.toUpperCase()
      @renderExplorerFacet(facetName, param)
    else 
      facetName = 'region'
      @renderExplorerFacet(facetName, param)

  byTheme: (param) ->
    facetName = 'thematic_focus'
    @renderExplorerFacet(facetName, param)

  byPartner: (param) ->
    facetName = 'partner_type'
    @renderExplorerFacet(facetName, param)

  byRole: (param) ->
    facetName = 'undp_role_type'
    @renderExplorerFacet(facetName, param)

  renderExplorerFacet: (facetName, facetValue) ->
    app.projects.clearFilters()
    app.projects.addFilter(facetName, facetValue) if facetName && facetValue
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


