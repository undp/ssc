class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  events:
    'click #filters': '_showHideAllFilters'
    'click .filter-group': '_showHideFilterGroup'
    'click .group-item[data-active-filter="false"]': '_addFilter'
    'click .group-item[data-active-filter="true"]': '_removeFilter'
    'click .active-filter': '_removeFilter'
    'click .reset-filters': '_resetFilters'


  initialize:  () ->
    @state = app.state

    @listenTo @state, 'search:foundFilters', @_showFilterSearchResults
    @listenTo @state, 'search:stopped', @_hideFilterSearchResults
    @listenTo @collection, 'reset', @render

    @render()

  render: (options) =>
    filterGroups = options?.filterGroups || @_presentFilterGroups()
    compiled = @template()(
      activeFilters: @_prepareActiveFilters()
      collection: @collection
      filterGroups: filterGroups
      hasSearchResults: options?.hasSearchResults
    )
    @$el.html(compiled)
    _.defer => @_resize()

  _resize: ->
    $filters = $('.filters')
    container = $('.filters-container').height()
    head = $('.filter-head-block').height()
    margin = $filters.outerHeight() - $filters.height()
    target = (container - head - margin)
    $filters.height(target)

  _prepareActiveFilters: =>
    _.map @state.get('filterState'), (filter) ->
      filter.long = app.filters.nameFromShort(filter.value)
      filter

  _presentFilterGroups: =>
    @collection.presentFilterGroups()

  _showHideAllFilters: (ev) ->
    ev.preventDefault()
    @$el.find('.filters').toggle()
    @$el.find('img.filters-disclose').toggleClass('displayed')

  _showHideFilterGroup: (ev) ->
    ev.preventDefault()
    $(ev.target).siblings().toggle()

  _addFilter: (ev) =>
    ev.preventDefault()
    elem = ev.currentTarget
    @state.addFilter(
      facetName: elem.getAttribute('data-filter-name')
      facetValue: elem.getAttribute('data-filter-value')
    )

  _removeFilter: (ev) =>
    ev.preventDefault()
    elem = ev.currentTarget
    @state.removeFilter(
      facetName: elem.getAttribute('data-filter-name')
      facetValue: elem.getAttribute('data-filter-value')
    )

  _resetFilters: (ev) =>
    ev.preventDefault()
    @state.clearFilters()

  _showFilterSearchResults: (results) =>
    @_receivedSearchResults = true
    @render(hasSearchResults: true, filterGroups: results) 

  _hideFilterSearchResults: =>
    @render() if @_receivedSearchResults? # Render original filterGroups
