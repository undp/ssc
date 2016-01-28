# Mixin for Projects Collection
ProjectsFacets =

  facetTypes: [
    'region'
    'territorial_focus'
    'thematic_focus'
    'undp_role_type'
    'partner_type'
    'country'
  ]

  initializeFacets: (options) ->
    @listenTo @, 'reset', @_initializeFacetr

  #
  # Backbone.Facetr setup
  #

  _initializeFacetr: ->
    @facetr ||= Facetr(@, 'projects')
    @_addStandardFacets() unless (@_facets().length == @facetTypes.length)

  _addStandardFacets: ->
    _.each @facetTypes, (type) =>
      @facetr.facet(type).desc()


  #
  # FACET ACTIONS
  #

  addFacet: (facetName, facetValue) ->
    @facetr.facet(facetName).value(facetValue, 'and')

  removeFacet: (facetName, facetValue) ->
    @facetr.facet(facetName).removeValue(facetValue)

  clearFilters: ->
    @facetr.clearValues()


  #
  # PRESENT FILTER GROUPS
  #

  presentFilterGroups: -> # TODO: @refac This is for display, so could be in a Presenter class/mixin
    @_sortFacetsByActiveCount()

    _.map(@_facets(), (facet) =>
      facet.values = @prepareFilterGroupForType(facet.data.name)
      facet
    )

  prepareFilterGroupForType: (facetName, options) ->
    throw 'Invalid filterGroup facetName given' unless _.include(@facetTypes, facetName)

    filterGroup = @_removeEmptyFacetValues(@_facetsObject()[facetName])

    if options?.sortBy == 'name'
      filterGroup = _.sortBy(filterGroup, 'long')
    else
      filterGroup = @_removeZeroActiveCount(filterGroup)


    # TODO: @temp_fix Removing 'None' in territorial_focus filter
    if facetName == 'territorial_focus'
      filterGroup = _.filter(filterGroup, (i) ->
        i.value != 'none'
      )

    # Convert values from short to long names
    _.map filterGroup, (filterItem) ->
      filterItem.long = app.filters.nameFromShort(filterItem.value)
      filterItem

  projectCountForFacetValue: (facetName, facetValue) ->
    throw 'Invalid filterGroup facetName given' unless _.include(@facetTypes, facetName)
    throw 'Invalid facetValue' unless facetValue?

    facet = @_facetsObject()[facetName]
    _.findWhere(facet, {value: facetValue.toLowerCase()})?.activeCount || 0


  #
  # FACET UTILITIES
  #

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

  _removeEmptyFacetValues: (values) ->
    _.filter(values, (i) ->
      i.value != "" and i.value != "n/a"
    )

  _removeZeroActiveCount: (values) ->
    _.filter(values, (i) ->
      i.activeCount > 0
    )
