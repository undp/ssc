class ExplorerView extends Backbone.View
  template: ->  _.template($('#explorerView').html())

  className: 'row'

  id: 'explorer'

  events: 
    'click .tab-menu-link': 'selectTabLink'

  render: ->
    compiled = @template()()
    @$el.html(compiled)

    @controlsView = new ControlsView(el: @$el.find('#controls'), collection: @collection)
    @controlsView.render()

    @contentView = new ContentView(el: @$el.find('#content'), collection: @collection)
    @contentView.render()

    @

  remove: ->
    @filterView.remove() if @filterView
    @contentView.remove() if @contentView

  selectTabLink: (ev) =>
    tabAttr = 'data-w-tab'
    linkActive = 'w--current'
    tabActive = 'w--tab-active'

    tab = ev.currentTarget.getAttribute(tabAttr)

    @$el.find('.tab-menu-link').removeClass(linkActive)
    @$el.find(".tab-menu-link[data-w-tab='#{tab}']").addClass(linkActive)

    @$el.find('.w-tab-pane').removeClass(tabActive)
    @$el.find(".w-tab-pane[data-w-tab='#{tab}']").addClass(tabActive)
