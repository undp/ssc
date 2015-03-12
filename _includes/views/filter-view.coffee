class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  events:
    'click [data-ix="showhide-all-filters"]': '_showHideAllFilters'
    'click [data-ix="showhide-filter-groups"]': '_showHideFilterGroup'
    'click .group-item[data-active-filter="false"]': '_addFilter'
    'click .group-item[data-active-filter="true"]': '_removeFilter'
    'click .active-filter': '_removeFilter'
    'click .reset-filters': '_resetFilters'


  initialize:  () ->
    @state = app.state

    @listenTo @state, 'search:foundFilters', @_showFilterSearchResults
    @listenTo @state, 'search:stopped', @_hideFilterSearchResults

    @listenTo @collection, 'reset', @render
    @listenTo app.state, 'filters:changed', @render

    @render()

  render: (options) =>
    filterGroups = options?.filterGroups || @_prepareFilterGroups()
    compiled = @template()(
      activeFilters: @_prepareActiveFilters()
      collection: @collection
      filterGroups: filterGroups
      searchResults: options?.searchResults
    )
    @$el.html(compiled)

  _prepareActiveFilters: =>
    _.map app.state.filterState, (filter) ->
      filter.long = app.filters.nameFromShort(filter.value)
      filter

  _prepareFilterGroups: =>
    @collection.prepareFilterGroups()

  _showHideAllFilters: (ev) ->
    ev.preventDefault()
    @$el.find('.toggle-filter-controls').toggle()
    @$el.find('img.filters-disclose').toggleClass('displayed')

  _showHideFilterGroup: (ev) ->
    ev.preventDefault()
    $(ev.target).siblings().toggle()

  _addFilter: (ev) =>
    ev.preventDefault()
    data = ev.currentTarget.dataset
    @state.addFilter(facetName: data.filterName, facetValue: data.filterValue)

  _removeFilter: (ev) =>
    ev.preventDefault()
    data = ev.currentTarget.dataset
    @state.removeFilter(facetName: data.filterName, facetValue: data.filterValue)

  _resetFilters: (ev) =>
    ev.preventDefault()
    @state.clearFilters()

  _showFilterSearchResults: (results) =>
    @_receivedSearchResults = true
    @render(searchResults: true, filterGroups: results) 

  _hideFilterSearchResults: =>
    @render() if @_receivedSearchResults? # Render original filterGroups
