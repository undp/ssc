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
    @listenTo @, 'add', @initFacetr
    @listenTo @, 'set', @initFacetr

    @resetState()

  resetState: ->
    @filterState = [] # TODO: Probably move from this Collection to a ViewModel
    @viewState = INITIAL_VIEW_STATE # TODO: Definitely move from this Collection to a ViewModel

  initFacetr: ->
    @facetr ||= Facetr(@, 'projects')
    @addStandardFacets() unless @facets().length == @facetTypes.length

  findBySearch: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || i.get('project_objective').match(term)

  # 
  # Facets
  # 
  addStandardFacets: ->
    _.each @facetTypes, (type) =>
      @facetr.facet(type).desc()

  facets: -> # @facetr.toJSON()
    @facetr.toJSON()

  facetsObject: ->
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
    @addFilterState(name, value, trigger)

  addFilterState: (facetName, facetValue, trigger) => # Triggers filters:add 
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
    @removeFilterState(name, value, trigger)

  removeFilterState: (facetName, facetValue, trigger) => # Triggers filters:remove
    foundFilter = _.findWhere(@filterState, 
      name: facetName
      value: facetValue
    )
    @filterState = _.without(@filterState, foundFilter)

    @trigger 'filters:remove' unless !trigger

  clearFilters: => # Triggers filters:reset 
    @resetState()
    @facetr.clearValues()
    @trigger 'filters:remove'

  sortFacetsByActiveCount: ->
    _.each(@facetr.facets(), (facet) =>
      facet.sortByActiveCount()
    )

  # 
  # PREPARE Facets for display
  # 
  prepareFilterGroups: ->
    @sortFacetsByActiveCount()

    _.map(@facets(), (facet) =>
      facet.values = @removeEmptyValuesFrom(facet.values)
      facet
    )

  prepareFilterGroupForType: (type) ->
    throw 'Invalid filterGroup type given' unless _.include(@facetTypes, type)
    @removeEmptyValuesFrom(@facetsObject()[type])

  removeEmptyValuesFrom: (values) ->
    _.filter(values, (i) =>
      i.activeCount > 0 && i.value != ""
    )
