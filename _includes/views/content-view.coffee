class ContentView extends Backbone.View
  template: -> _.template($('#contentView').html())

  events:
    'click .tab-menu-link': 'selectTabLink'

  initialize: ->
    @childViews =
      map   : new MapView(parentView: @, collection: @collection)
      stats : new StatsView(parentView: @, collection: @collection)
      list  : new ListView(parentView: @, collection: @collection)

    @render()

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)

    _.each @childViews, (view) -> view.render()

    @setActiveTab('map') # TODO: Refer to viewModel
    @

  selectTabLink: (ev) =>
    ev.preventDefault()
    tab = ev.currentTarget.getAttribute('data-w-tab')
    @setActiveTab(tab)

  setActiveTab: (tab) ->
    linkActive = 'w--current'
    tabActive = 'w--tab-active'

    @$el.find('.tab-menu-link').removeClass(linkActive)
    @$el.find(".tab-menu-link[data-w-tab='#{tab}']").addClass(linkActive)

    @$el.find('.w-tab-pane').removeClass(tabActive)
    @$el.find(".w-tab-pane[data-w-tab='#{tab}']").addClass(tabActive)

