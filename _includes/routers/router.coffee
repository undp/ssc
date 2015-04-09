Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

  routes:
    ''               : '_explorerRoute'
    'manage'          : '_renderAdminView'
    ':action/:value' : '_explorerRoute'
    '*notFound'      : '_notFound'

  # 
  # ROUTES
  # 
  _explorerRoute: (action, value) ->
    app.state.attemptRestoreStateFromUrl(
      fallbackAction: action
      fallbackValue: value
      stateRef: app.utils.getUrlParams().stateRef
    )

    @_renderExplorerView()

  _notFound: (notFound) ->
    console.warn 'No route matched', notFound
    @navigate '', trigger: false
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
