Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

  routes:
    "": "root"
    "theme/:theme": "byTheme"
    "location/:iso3": "byLocation"
    "partner/:partner_type": "byPartner"
    "role/:undp_role": "byRole"
    "project/:id": "project"
    "search/:term": "search"
  
  root: ->
    collection = app.projects
    @switchView(null, collection)

  byTheme: (theme) ->
    filtered = app.projects.filterByTheme(theme)
    collection = new Projects(filtered)
    @switchView(null, collection)

  byLocation: (iso3) ->
    filtered = app.projects.filterByLocation(iso3)
    collection = new Projects(filtered)
    @switchView(null, collection)

  byPartner: (partner_type) ->
    filtered = app.projects.filterByPartner(partner_type)
    collection = new Projects(filtered)
    @switchView(null, collection)

  byRole: (role) ->
    filtered = app.projects.filterByRole(role)
    collection = new Projects(filtered)
    @switchView(null, collection)

  project: (id) ->
    @view.remove() if @view
    project = projects.get(id)
    @view = new ProjectView(model: project)
    @$appEl.html(@view.render())

  switchView: (view, collection) ->
    @view.remove() if @view
    view = ExplorerView unless view

    @view = new view(collection: collection)
    @$appEl.html(@view.render())

