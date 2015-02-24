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
    # TODO: console.log 'render filters'

    _.each(@collection.facetr.facets(), (facet) =>
      facet.sortByActiveCount()
    )
    _.map(@collection.facets(), (facet) =>
      facet.values = _.filter(facet.values, (i) =>
        i.activeCount > 0 && i.value != ""
      )
      facet = @presentCountryFacet(facet)
      facet
    )

  presentCountryFacet: (facet) ->
    if facet.data.name == 'host_location' && facet.values.length > 5
      facet.data.hideCountries = true
    facet


  showHideAllFilters: ->
    @$el.find('.filters').toggle()

  showHideFilterGroup: (ev) ->
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
        i.get('forFilter')
      )
    else
      @resetFilterGroups()
    @render()
