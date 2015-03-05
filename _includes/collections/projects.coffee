API_KEY            = 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
APP_ID             = 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
API_URL            = 'https://api.parse.com/1/classes/stateData'
INITIAL_VIEW_STATE = 'list'

class Projects extends Backbone.Collection
  facetTypes: [
    'undp_role_type', 
    'thematic_focus', 
    'host_location', 
    'region', 
    'territorial_focus', 
    'partner_type'
  ]

  url: '{{site.baseurl}}/api/projects.json'

  model: Project

  initialize: ->
    @listenTo @, 'add', @_initFacetr
    @listenTo @, 'set', @_initFacetr

    @_resetState()

  _resetState: ->
    @filterState = [] # TODO: Probably move from this Collection to a ViewModel
    @viewState = INITIAL_VIEW_STATE # TODO: Definitely move from this Collection to a ViewModel

  _initFacetr: ->
    @facetr ||= Facetr(@, 'projects')
    @_addStandardFacets() unless @_facets().length == @facetTypes.length

  findBySearch: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || i.get('project_objective').match(term)

  # 
  # Facets
  # 
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

  addFilter: (options) =>
    {name, value, trigger} = options
    trigger ?= true

    console.warn "TODO: Need to check facet is valid (esp. if country)"

    return "Can't add duplicate Facet" if _.findWhere(@filterState, 
      name: name
      value: value
    )
    @facetr.facet(name).value(value, 'and')
    @_addFilterState(name, value, trigger)

  _addFilterState: (facetName, facetValue, trigger) => # Triggers filters:add 
    @filterState.push 
      name: facetName
      value: facetValue
    @trigger 'filters:add' unless !trigger

  removeFilter: (options) =>
    {name, value, trigger} = options
    # TODO: Check value if valid for facet, i.e. is it an active filter?
    return "Can't remove non-existent Facet" unless _.findWhere(@filterState, 
      name: name
      value: value
    )
    @facetr.facet(name).removeValue(value)
    @_removeFilterState(name, value, trigger)

  _removeFilterState: (facetName, facetValue, trigger) => # Triggers filters:remove
    foundFilter = _.findWhere(@filterState, 
      name: facetName
      value: facetValue
    )
    @filterState = _.without(@filterState, foundFilter)

    @trigger 'filters:remove' unless !trigger

  clearFilters: => # Triggers filters:reset 
    @_resetState()
    @facetr.clearValues()
    @trigger 'filters:remove'

  _sortFacetsByActiveCount: ->
    _.each(@facetr.facets(), (facet) =>
      facet.sortByActiveCount()
    )

  # 
  # PREPARE _Facets for display
  # 
  prepareFilterGroups: ->
    @_sortFacetsByActiveCount()

    _.map(@_facets(), (facet) =>
      facet.values = @_removeEmptyValuesFrom(facet.values)
      facet
    )

  prepareFilterGroupForType: (type) ->
    throw 'Invalid filterGroup type given' unless _.include(@facetTypes, type)
    @_removeEmptyValuesFrom(@_facetsObject()[type])

  _removeEmptyValuesFrom: (values) ->
    _.filter(values, (i) =>
      i.activeCount > 0 && i.value != ""
    )
