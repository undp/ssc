Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

  routes:
    "": "redirect"
    "all": "all"
    "location/:iso3": "byLocation"
    "theme/:theme": "byTheme"
    "partner/:partner_type": "byPartner"
    "role/:undp_role": "byRole"
    "project/:id": "project"
    "search/:term": "search"
  
  redirect: ->
    @navigate 'all', trigger: true

  all: ->
    app.faceted.clear()
    view = new ExplorerView(collection: app.projects)
    @switchView(view, app.projects)

  byLocation: (param) ->
    facet_name = 'host_location'
    param = param.toUpperCase()
    @explorerFacet(facet_name, param)

  byTheme: (param) ->
    facet_name = 'thematic_focus'
    @explorerFacet(facet_name, param)

  byPartner: (param) ->
    facet_name = 'partner_type'
    @explorerFacet(facet_name, param)

  byRole: (param) ->
    facet_name = 'undp_role_type'
    @explorerFacet(facet_name, param)

  explorerFacet: (facet_name, param) ->
    app.faceted.clear()
    app.faceted.facet(facet_name).value(param)
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

