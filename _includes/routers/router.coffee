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
    "map": "testMap"
  
  redirect: ->
    @navigate 'all', trigger: true

  all: ->
    @explorerFacet()

  byLocation: (param) ->
    if app.countries.nameFromIso(param)
      facet_name = 'host_location'
      param = param.toUpperCase()
      @explorerFacet(facet_name, param)
    else 
      facet_name = 'region'
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
    app.projects.facetr.clearValues()
    app.projects.facetr.facet(facet_name).value(param) if facet_name && param
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

  testMap: ->
    console.log 'thing'

