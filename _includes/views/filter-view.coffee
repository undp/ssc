class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  events:
    'click .activeFilter': 'removeFilter'
    'click .addFilter': 'addFilter'
    'click .resetFilters': 'resetFilters'
    'click .scrollContents': 'scrollContents'
    'click .toggleHiddenCountries': 'toggleHiddenCountries'

  initialize:  (options) ->
    @options = options || {}

    @listenTo @collection, 'reset', @render
    @listenTo @collection, 'filters:reset', @render
    @listenTo app.vent, 'search', @search # TODO: Wrong place to listen for this

  render: =>
    compiled = @template()(
      activeFilters: @collection.filterState
      collection: @collection
      filterGroups: @filterGroups()
    )
    @$el.html(compiled)

  scrollContents: ->
    $('html, body').animate({scrollTop: $("#content").offset().top}, 500)

  toggleHiddenCountries: =>
    @$el.find('.toggleHiddenCountries').toggle()
    $('.hiddenCountries').toggle()

  addFilter: (ev) =>
    ev.preventDefault()
    data = ev.target.dataset
    @collection.addFilter(data.filterName, data.filterValue)

  removeFilter: (ev) =>
    ev.preventDefault()
    data = ev.target.dataset
    @collection.removeFilter(data.filterName, data.filterValue)

  resetFilters: =>
    @collection.clearFilters()

  filterGroups: =>
    console.log 'render filters'

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

  search: (term) ->
    if term
      @filterGroups = _.groupBy(app.filters.search(term), (i) ->
        i.get('forFilter')
      )
    else
      @resetFilterGroups()
    @render()

  # searchTitle: (term) ->
  #   app.projects.facetr.removeFilter('searchTitle')
  #   app.projects.facetr.addFilter('searchTitle', (model) ->
  #     re = new RegExp(term, "i")
  #     model.get('project_title').match(re)
  #   )
