class ContentView extends Backbone.View
  template: -> _.template($('#contentView').html())

  events:
    'click .tab-menu-link': 'selectTabLink'

  initialize: ->
    @listenTo @collection, 'reset', @render
    @map = new MapView(contentView: @, collection: @collection)
    @render()

  render: ->
    # TODO: console.log 'reset collection -> render contentView'
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    @selectTab('map')
    @

  selectTabLink: (ev) =>
    tab = ev.currentTarget.getAttribute('data-w-tab')
    @selectTab(tab)

  selectTab: (tab) ->
    linkActive = 'w--current'
    tabActive = 'w--tab-active'

    @$el.find('.tab-menu-link').removeClass(linkActive)
    @$el.find(".tab-menu-link[data-w-tab='#{tab}']").addClass(linkActive)

    @$el.find('.w-tab-pane').removeClass(tabActive)
    @$el.find(".w-tab-pane[data-w-tab='#{tab}']").addClass(tabActive)

