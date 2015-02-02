class ExplorerView extends Backbone.View
  template: ->  _.template($('#explorerView').html())

  initialize: ->

  render: ->
    @viewModel = new ControlsViewModel
    @viewModel.set('shape', 'curvy')

    compiled = @template()(@viewModel)
    @$el.html(compiled)

    @controlsView = new ControlsView(collection: @collection, model: @viewModel, viewModel: @viewModel)
    @controlsView.render()
    @$el.find('#controls').html(@controlsView.$el)

    @contentView = new ContentView(collection: @collection, model: @viewModel)
    @contentView.render()
    @$el.find('#content').html(@contentView.$el)

    @

  remove: ->
    @filterView.remove() if @filterView
    @contentView.remove() if @contentView