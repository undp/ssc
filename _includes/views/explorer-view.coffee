class ExplorerView extends Backbone.View
  template: ->  _.template($('#explorerView').html())

  render: ->
    compiled = @template()()
    @$el.html(compiled)

    @headlinesView = new HeadlinesView(el: @$el.find('#headlines'), collection: @collection)
    @controlsView = new ControlsView(el: @$el.find('#controls'), collection: @collection)
    @contentView = new ContentView(el: @$el.find('#content'), collection: @collection)

    @

  remove: ->
    @filterView.remove() if @filterView
    @contentView.remove() if @contentView

