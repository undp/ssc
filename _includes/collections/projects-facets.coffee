# Mixin for Projects Collection
ProjectsFacets =

  initializeFacets: (options) ->
    @listenTo @, 'reset', @_initializeFacetr

  facetTypes: [
    'region'
    'territorial_focus'
    'thematic_focus'
    'undp_role_type'
    'partner_type'
    'host_location'
  ]

  addFilter: (facetName, facetValue) ->

    console.warn "TODO: Need to check facet is valid (esp. if country)"
    @facetr.facet(options.facetName).value(options.facetValue, 'and')

  removeFilter: (facetName, facetValue) ->
    @facetr.facet(facetName).removeValue(facetValue)
    
  clearFilters: -> # Triggers filters:changed
    return if app.state.filterState.length is 0
    app.state.trigger 'state:reset' # TODO: Coupling?
    @facetr.clearValues()
    # @trigger 'filters:changed'

  prepareFilterGroups: -> # TODO: This is for display, so could be in a Presenter
    @_sortFacetsByActiveCount()

    _.map(@_facets(), (facet) =>
      facet.values = @prepareFilterGroupForType(facet.data.name)
      facet
    )

  prepareFilterGroupForType: (type) ->
    throw 'Invalid filterGroup type given' unless _.include(@facetTypes, type)
    filterGroup = @_removeEmptyValuesFrom(@_facetsObject()[type])
    # Convert values from short to long names
    _.map filterGroup, (filterItem) ->
      filterItem.long = app.filters.nameFromShort(filterItem.value)
      filterItem

  projectCountForFacetValue: (type, value) ->
    throw 'Invalid filterGroup type given' unless _.include(@facetTypes, type)
    throw 'Invalid value' unless value?

    facet = @_facetsObject()[type]
    _.findWhere(facet, {value: value.toLowerCase()})?.activeCount || 0

  filterFacets: (searchTerm) ->
    return unless searchTerm?

    activeFilters = @prepareFilterGroups()
    @_createFilterGroups(@_findMatches(searchTerm))

  _findMatches: (searchTerm) ->
    app.filters.search(searchTerm)

  _createFilterGroups: (filterObjects) ->
    collection = new Backbone.Collection(filterObjects)

  _searchByLongName: (term, facetsObject) ->
    new Backbone.Collection(app.filters.search(term)).pluck('short')

  _initializeFacetr: ->
    @facetr ||= Facetr(@, 'projects')
    @_addStandardFacets() unless @_facets().length == @facetTypes.length

  _addStandardFacets: ->
    _.each @facetTypes, (type) =>
      @facetr.facet(type).desc()

  _facets: -> # @facetr.toJSON()
    @facetr.toJSON()

  _facetsObject: ->
    _.object(
      _.map @facetr.toJSON(), (facet) ->
        [facet.data.name, facet.values]
    )

  _sortFacetsByActiveCount: ->
    _.each(@facetr.facets(), (facet) =>
      facet.sortByActiveCount()
    )

  _removeEmptyValuesFrom: (values) ->
    _.filter(values, (i) =>
      i.activeCount > 0 && i.value != ""
    )
