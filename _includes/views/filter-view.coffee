class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  events:
    'click [data-ix="showhide-all-filters"]': 'showHideAllFilters'
    'click [data-ix="showhide-filter-groups"]': 'showHideFilterGroup'
    'click .group-item': 'addFilter'

    # 'click .activeFilter': 'removeFilter'
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
      filterGroups: @prepareFilterGroups()
    )
    @$el.html(compiled)

  prepareFilterGroups: =>
    @collection.prepareFilterGroups()

  showHideAllFilters: (ev) ->
    ev.preventDefault()
    @$el.find('.filters').toggle()

  showHideFilterGroup: (ev) ->
    ev.preventDefault()
    $(ev.target).siblings().toggle()

  addFilter: (ev) =>
    ev.preventDefault()
    data = ev.currentTarget.dataset
    @collection.addFilter(name: data.filterName, value: data.filterValue)

  # removeFilter: (ev) =>
  #   ev.preventDefault()
  #   data = ev.target.dataset
  #   @collection.removeFilter(name: data.filterName, value: data.filterValue)

  # resetFilters: =>
  #   @collection.clearFilters()



  search: (term) ->
    if term
      @filterGroups = _.groupBy(app.filters.search(term), (i) ->
        i.get('filterTitle')
      )
    else
      @resetFilterGroups()
    @render()
