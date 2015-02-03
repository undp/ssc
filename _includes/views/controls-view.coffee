class ControlsView extends Backbone.View
  template: -> _.template($('#controlsView').html())

  initialize:  (options) ->
    @options = options || {}
    @viewModel = @options.viewModel || new ControlsViewModel

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)

    @searchView = new SearchView(el: @$el.find('#search'), collection: @collection, viewModel: @viewModel)
    @searchView.render()

    @filterView = new FilterView(el: @$el.find('#filter'), collection: @collection, viewModel: @viewModel)
    @filterView.render()

    @
