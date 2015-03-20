# Mixin for Projects Collection
ProjectsFacets =

  initializeFacets: (options) ->
    @listenTo @, 'reset', @_initializeFacetr

  _initializeFacetr: ->
    @facetr ||= Facetr(@, 'projects')
    @_addStandardFacets() unless (@_facets().length == @facetTypes.length)

  facetTypes: [
    'region'
    'territorial_focus'
    'thematic_focus'
    'undp_role_type'
    'partner_type'
    'country'
  ]

  addFacet: (facetName, facetValue) ->
    @facetr.facet(facetName).value(facetValue, 'and')

  removeFacet: (facetName, facetValue) ->
    @facetr.facet(facetName).removeValue(facetValue)

  clearFilters: ->
    @facetr.clearValues()

  prepareFilterGroups: -> # TODO: This is for display, so could be in a Presenter
    @_sortFacetsByActiveCount()

    _.map(@_facets(), (facet) =>
      facet.values = @prepareFilterGroupForType(facet.data.name)
      facet
    )

  prepareFilterGroupForType: (facetName) ->
    throw 'Invalid filterGroup facetName given' unless _.include(@facetTypes, facetName)
    filterGroup = @_removeEmptyValuesFrom(@_facetsObject()[facetName])
    # Convert values from short to long names
    _.map filterGroup, (filterItem) ->
      filterItem.long = app.filters.nameFromShort(filterItem.value)
      filterItem

  projectCountForFacetValue: (facetName, facetValue) ->
    throw 'Invalid filterGroup facetName given' unless _.include(@facetTypes, facetName)
    throw 'Invalid facetValue' unless facetValue?

    facet = @_facetsObject()[facetName]
    _.findWhere(facet, {value: facetValue.toLowerCase()})?.activeCount || 0

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

  _addStandardFacets: ->
    _.each @facetTypes, (type) =>
      @facetr.facet(type).desc()

  _facets: -> @facetr.toJSON()

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
