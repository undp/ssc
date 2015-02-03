class ExplorerView extends Backbone.View
  template: ->  _.template($('#explorerView').html())

  className: 'row'

  id: 'explorer'

  initialize: ->

  render: ->
    @viewModel = new ControlsViewModel

    compiled = @template()(@viewModel)
    @$el.html(compiled)

    @controlsView = new ControlsView(el: @$el.find('#controls'), collection: @collection, viewModel: @viewModel)
    @controlsView.render()

    @contentView = new ContentView(el: @$el.find('#content'), collection: @collection, viewModel: @viewModel)
    @contentView.render()

    @

  remove: ->
    @filterView.remove() if @filterView
    @contentView.remove() if @contentView