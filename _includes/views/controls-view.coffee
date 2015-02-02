class ControlsView extends Backbone.View
  template: -> _.template($('#controlsView').html())

  initialize:  (options) ->
    @options = options || {}
    @viewModel = @options.viewModel || new ControlsViewModel

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)

    @searchView = new SearchView(collection: @collection, viewModel: @viewModel)
    @searchView.render()
    @$el.find('#search').html(@searchView.$el)

    @filterView = new FilterView(collection: @collection, viewModel: @viewModel)
    @filterView.render()
    @$el.find('#filter').html(@filterView.$el)

    @
