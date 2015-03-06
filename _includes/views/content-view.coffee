class ContentView extends Backbone.View
  template: -> _.template($('#contentView').html())

  events:
    'click .tab-menu-link': '_selectTabLink'

  initialize: ->
    @childViews =
      map   : new MapView(collection: @collection)
      stats : new StatsView(parentView: @, collection: @collection)
      list  : new ListView(parentView: @, collection: @collection)

    @render()

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)

    _.each(@childViews, (view) -> view.render())

    activeTab = app.state.viewState
    @_setActiveTab(activeTab)
    @

  _selectTabLink: (ev) =>
    ev.preventDefault()
    tab = ev.currentTarget.getAttribute('data-w-tab')
    @_setActiveTab(tab)

  _setActiveTab: (tab) ->
    linkActive = 'w--current'
    tabActive = 'w--tab-active'

    @$el.find('.tab-menu-link').removeClass(linkActive)
    @$el.find(".tab-menu-link[data-w-tab='#{tab}']").addClass(linkActive)

    @$el.find('.w-tab-pane').removeClass(tabActive)
    @$el.find(".w-tab-pane[data-w-tab='#{tab}']").addClass(tabActive)

    app.state.trigger 'view:changed', tab

