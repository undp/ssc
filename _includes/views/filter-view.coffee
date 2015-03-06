class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  events:
    'click [data-ix="showhide-all-filters"]': '_showHideAllFilters'
    'click [data-ix="showhide-filter-groups"]': '_showHideFilterGroup'
    'click .group-item[data-active-filter="false"]': '_addFilter'
    'click .group-item[data-active-filter="true"]': '_removeFilter'
    # 'click .resetFilters': 'resetFilters'


  initialize:  (options) ->
    @options = options || {}

    @listenTo @collection, 'reset', @render
    @listenTo @collection, 'filters:add', @render
    @listenTo @collection, 'filters:remove', @render
    @listenTo @collection, 'filters:reset', @render

    @render()

  render: =>
    compiled = @template()(
      activeFilters: @collection.filterState
      collection: @collection
      filterGroups: @_prepareFilterGroups()
    )
    @$el.html(compiled)

  _prepareFilterGroups: =>
    @collection.prepareFilterGroups()

  _showHideAllFilters: (ev) ->
    ev.preventDefault()
    @$el.find('.filters').toggle()

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

  # resetFilters: =>
  #   @collection.clearFilters()

  # search: (term) ->
  #   if term
  #     @filterGroups = _.groupBy(app.filters.search(term), (i) ->
  #       i.get('filterTitle')
  #     )
  #   else
  #     @resetFilterGroups()
  #   @render()
