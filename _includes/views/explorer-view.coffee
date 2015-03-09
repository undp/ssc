class ExplorerView extends Backbone.View
  template: ->  _.template($('#explorerView').html())

  initialize: ->

  render: ->
    compiled = @template()()
    @$el.html(compiled)

    @headlinesView = new HeadlinesView(el: @$el.find('#headlines'), collection: @collection)
    @controlsView = new ControlsView(el: @$el.find('#controls'), collection: @collection)
    @contentView = new ContentView(el: @$el.find('#content'), collection: @collection)
    @

  remove: ->
    @headlinesView.remove() if @headlinesView
    @filterView.remove() if @filterView
    @contentView.remove() if @contentView
    Backbone.View.prototype.remove.apply(this, arguments);