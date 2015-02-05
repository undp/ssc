class ExplorerView extends Backbone.View
  template: ->  _.template($('#explorerView').html())

  className: 'row'

  id: 'explorer'

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