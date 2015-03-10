class ControlsView extends Backbone.View
  template: -> _.template($('#controlsView').html())

  initialize: ->
    @render()

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)

    @searchView = new SearchView(el: @$el.find('.search-container'), collection: @collection)
    @filterView = new FilterView(el: @$el.find('.filters-container.filters'), collection: @collection)
    # @searchResultsView = new SearchResultsView(el: @$el.find('.filters-container.search-results'))
    @
