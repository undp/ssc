Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

  routes:
    ''               : '_explorer'
    'admin'          : '_admin'
    ':action/:value' : '_explorer'
    '*notFound'      : '_notFound'

  _notFound: (notFound) ->
    console.warn 'No route matched', notFound
    @navigate '', trigger: false
    @_explorerView()
  
  # ROUTES
  _explorer: (action, value) ->
    app.state.restoreStateFromUrl(fallbackAction: action, fallbackValue: value, stateRef: @_params().stateRef)
    @_explorerView()

  _explorerView: ->
    view = new ExplorerView(collection: app.projects)
    @_switchView(view)

  _admin: ->
    view = new AdminView(collection: app.projects)
    @$appEl.html('')
    @$appEl = $("#admin-app")
    @_switchView(view)

  # View management
  _switchView: (newView) ->
    @view.remove() if @view
    @view = newView
    @view.render()
    @$appEl.html(@view.$el)

  _params: -> app.utils.getUrlParams()
