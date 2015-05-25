Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

  routes:
    ''               : '_explorerRoute'
    'manage'          : '_renderAdminView'
    ':action/:value' : '_explorerRoute' # Either filter or Project
    '*notFound'      : '_notFound'

  # 
  # ROUTES
  # 
  _explorerRoute: (action, value) ->
    options = 
      action : action
      value  : value
      params : app.utils.getUrlParamsHash()

    callback = => @_renderExplorerView()

    app.state.attemptRestoreStateFromUrl(options, callback)


  _notFound: (notFound) ->
    console.warn 'No route matched', notFound
    @navigate('')
    @_renderExplorerView()

  # 
  # PREPARE VIEWS
  # 
  _renderExplorerView: ->
    view = new ExplorerView(collection: app.projects)
    @_switchView(view)

  _renderAdminView: ->
    view = new AdminView(collection: app.projects)
    @$appEl.html('')
    @$appEl = $("#admin-app")
    @_switchView(view)

  # 
  # VIEW MANAGEMENT
  # 
  _switchView: (newView) ->
    @view.remove() if @view
    @view = newView
    @view.render()
    @$appEl.html(@view.$el)
