class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  events:
    'click [data-ix="showhide-all-filters"]': '_showHideAllFilters'
    'click [data-ix="showhide-filter-groups"]': '_showHideFilterGroup'
    'click .group-item[data-active-filter="false"]': '_addFilter'
    'click .group-item[data-active-filter="true"]': '_removeFilter'
    'click .active-filter': '_removeFilter'
    'click .reset-filters': '_resetFilters'


  initialize:  (options) ->
    throw 'Missing parentView' unless options.parentView?
    {@parentView} = options

    @listenTo @parentView, 'search:foundFilters', @_showFilterSearchResults
    @listenTo @parentView, 'search:stopped', @_hideFilterSearchResults

    @listenTo @collection, 'reset', @render
    @listenTo @collection, 'filters:add', @render
    @listenTo @collection, 'filters:remove', @render
    @listenTo @collection, 'filters:reset', @render

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
    @collection.addFilter(name: data.filterName, value: data.filterValue)

  _removeFilter: (ev) =>
    ev.preventDefault()
    data = ev.currentTarget.dataset
    @collection.removeFilter(name: data.filterName, value: data.filterValue)

  _resetFilters: (ev) =>
    ev.preventDefault()
    @collection.clearFilters()

  _showFilterSearchResults: (results) =>
    @render(searchResults: true, filterGroups: results) 

  _hideFilterSearchResults: ->
    @render() # Render original filterGroups
