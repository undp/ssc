ProjectsFacets =

  initializeFacets: (options) ->
    @listenTo @, 'add', @_initializeFacetr
    @listenTo @, 'set', @_initializeFacetr


    @filterState = [] # TODO: Probably move from this Collection to a ViewModel
    @viewState = ''
    @_resetState()

  facetTypes: [
    'undp_role_type',
    'thematic_focus',
    'host_location',
    'region',
    'territorial_focus',
    'partner_type'
  ]

  addFilter: (options) ->
    {name, value, trigger} = options
    trigger ?= true

    console.warn "TODO: Need to check facet is valid (esp. if country)"

    return "Can't add duplicate Facet" if _.findWhere(@filterState,
      name: name
      value: value
    )
    @facetr.facet(name).value(value, 'and')
    @_addFilterState(name, value, trigger)

  removeFilter: (options) ->
    {name, value, trigger} = options
    # TODO: Check value if valid for facet, i.e. is it an active filter?
    return "Can't remove non-existent Facet" unless _.findWhere(@filterState,
      name: name
      value: value
    )
    @facetr.facet(name).removeValue(value)
    @_removeFilterState(name, value, trigger)

  clearFilters: -> # Triggers filters:reset
    @_resetState()
    @facetr.clearValues()
    @trigger 'filters:remove'

  prepareFilterGroups: -> # TODO: This is for display, so could be in a Presenter
    @_sortFacetsByActiveCount()

    _.map(@_facets(), (facet) =>
      facet.values = @_removeEmptyValuesFrom(facet.values)
      facet
    )

  prepareFilterGroupForType: (type) ->
    throw 'Invalid filterGroup type given' unless _.include(@facetTypes, type)
    @_removeEmptyValuesFrom(@_facetsObject()[type])

  _resetState: ->
    @filterState = [] # TODO: Probably move from this Collection to a ViewModel
    @viewState = INITIAL_VIEW_STATE # TODO: Definitely move from this Collection to a ViewModel

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

  _addFilterState: (facetName, facetValue, trigger) -> # Triggers filters:add
    @filterState.push
      name: facetName
      value: facetValue
    @trigger 'filters:add' unless !trigger

  _removeFilterState: (facetName, facetValue, trigger) -> # Triggers filters:remove
    foundFilter = _.findWhere(@filterState,
      name: facetName
      value: facetValue
    )
    @filterState = _.without(@filterState, foundFilter)

    @trigger 'filters:remove' unless !trigger

  _sortFacetsByActiveCount: ->
    _.each(@facetr.facets(), (facet) =>
      facet.sortByActiveCount()
    )

  _removeEmptyValuesFrom: (values) ->
    _.filter(values, (i) =>
      i.activeCount > 0 && i.value != ""
    )
