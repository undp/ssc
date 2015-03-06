ProjectsFacets =

  initializeFacets: (options) ->
    @listenTo @, 'add', @_initializeFacetr
    @listenTo @, 'set', @_initializeFacetr

  facetTypes: [
    'undp_role_type'
    'thematic_focus'
    'region'
    'territorial_focus'
    'partner_type'
    'host_location'
  ]

  addFilter: (options) ->
    {name, value, trigger} = options
    trigger ?= true

    if app.state.addFilterState(name, value, trigger)
      console.warn "TODO: Need to check facet is valid (esp. if country)"
      @facetr.facet(name).value(value, 'and')
    else
      return "Can't add duplicate Facet" 

  removeFilter: (options) ->
    {name, value, trigger} = options
    trigger ?= true

    if app.state.removeFilterState(name, value, trigger)

      @facetr.facet(name).removeValue(value)
    else# TODO: Check value if valid for facet, i.e. is it an active filter?
      return "Can't remove non-existent Facet" 
    

  clearFilters: -> # Triggers filters:reset
    app.state.resetState() # TODO: Coupling?
    @facetr.clearValues()
    @trigger 'filters:remove'

  prepareFilterGroups: -> # TODO: This is for display, so could be in a Presenter
    @_sortFacetsByActiveCount()

    _.map(@_facets(), (facet) =>
      facet.values = @prepareFilterGroupForType(facet.data.name)
      facet
    )

  prepareFilterGroupForType: (type) ->
    throw 'Invalid filterGroup type given' unless _.include(@facetTypes, type)
    @_removeEmptyValuesFrom(@_facetsObject()[type])

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
