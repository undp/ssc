class ExplorerView extends Backbone.View
  template: ->  _.template($('#explorerView').html())

  initialize: ->

  render: ->
    compiled = @template()()
    @$el.html(compiled)

    @_headlinesView = new HeadlinesView(el: @$el.find('#headlines'), collection: @collection)
    @_controlsView = new ControlsView(el: @$el.find('#controls'), collection: @collection)
    @_contentView = new ContentView(el: @$el.find('#content'), collection: @collection)
    @

  remove: ->
    @_headlinesView.remove() if @_headlinesView?
    @_controlsView.remove() if @_controlsView?
    @_contentView.remove() if @_contentView?
    Backbone.View.prototype.remove.apply(this, arguments)