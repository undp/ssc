Router = Backbone.Router.extend
  initialize: ->
    @$appEl ||= $("#app")

    @_routesHit = 0
    Backbone.history.on 'route', (-> @_routesHit++), @ # TODO: Still needed if handling ProjectShow as a view not a page?

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
    console.log 'admin'

  # View management
  _switchView: (newView) ->
    @view.remove() if @view
    @view = newView
    @view.render()
    @$appEl.html(@view.$el)

  # Back simpler
  back: ->
    if @_routesHit > 1 # User did not land directly on current page
      window.history.back()
    else
      console.log 'Check for a state in the URL, else -> _rootRoute'
      @navigate '', trigger: true, replace: true

  _params: -> app.utils.getUrlParams()
