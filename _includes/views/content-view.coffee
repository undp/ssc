class ContentView extends Backbone.View
  template: -> _.template($('#contentView').html())

  events:
    'click .tab-menu-link': '_selectTabLink'

  initialize: ->
    @state = app.state

    @listenTo @state, 'search:foundProjects', @_listTabForSearchResults
    @listenTo @state, 'search:stopped', @_restorePreviousTabAfterSearchResults

    @_setupMouseTrap()
    @render()

    @childViews =
      map   : new MapView(el: @$el.find('.tab-content[data-w-tab="map"]'), collection: @collection)
      stats : new StatsView(el: @$el.find('.tab-content[data-w-tab="stats"]'), collection: @collection)
      list  : new ListView(el: @$el.find('.tab-content[data-w-tab="list"]'), collection: @collection)

  render: ->
    compiled = @template()()
    @$el.html(compiled)

    _.defer => 
      console.warn 'Fix: deferring content childViews rendering'
      @_renderChildViews() # TODO: Replace `defer` until contentView rendered, but keep event bindings

    activeTab = @state.get('viewState')
    @_setActiveTab(activeTab)

    @

  remove: ->
    _.each(@childViews, (view) -> view.remove())
    @_projectShowView.remove() if @_projectShowView?
    Backbone.View.prototype.remove.apply(this, arguments)

  _renderChildViews: ->
    _.each(@childViews, (view) -> view.render())

  # 
  # Display modes
  # 

  _listTabForSearchResults: =>
    @_setActiveTab('list') # This doesn't trigger a 'change state' event

  _restorePreviousTabAfterSearchResults: =>
    activeTab = @state.get('viewState')
    @_setActiveTab(activeTab)

  # 
  # Tab controls
  # 
  _selectTabLink: (ev) =>
    ev.preventDefault()
    tab = ev.currentTarget.getAttribute('data-w-tab')
    @_saveStateAndSetActiveTab(tab)

  _saveStateAndSetActiveTab: (tab) =>
    @state.setViewState tab
    @_setActiveTab(tab)

  _setActiveTab: (tab) ->
    linkActive = 'w--current'
    tabActive = 'w--tab-active'

    @$el.find('.tab-menu-link').removeClass(linkActive)
    @$el.find(".tab-menu-link[data-w-tab='#{tab}']").addClass(linkActive)

    @$el.find('.w-tab-pane').removeClass(tabActive)
    @$el.find(".w-tab-pane[data-w-tab='#{tab}']").addClass(tabActive)

    if @childViews? and @childViews[tab].setActive?
      @childViews[tab].setActive() 

  # 
  # Keyboard shortcuts
  # 
  _setupMouseTrap: ->
    Mousetrap.bind '/', => 
      @state.trigger 'search:start'
      false
    Mousetrap.bind 'm', => @_saveStateAndSetActiveTab('map')
    Mousetrap.bind 's', => @_saveStateAndSetActiveTab('stats')
    Mousetrap.bind 'l', => @_saveStateAndSetActiveTab('list')
    Mousetrap.bind 'r', => @state.clearFilters()
