class ControlsView extends Backbone.View
  template: -> _.template($('#controlsView').html())

  initialize: ->
    @render()

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)

    @searchView = new SearchView(el: @$el.find('.search-container'), collection: @collection)
    @filterView = new FilterView(el: @$el.find('.filters-container.filters'), collection: @collection)
    @searchedFiltersView = new SearchedFiltersView(el: @$el.find('.filters-container.searched-filters'), collection: @collection)
    @
