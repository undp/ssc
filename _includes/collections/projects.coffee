class Projects extends Backbone.Collection
  types: [
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
    @listenTo @, 'set', @initFacetr
    @filterState = []

  initFacetr: ->
    @facetr = Facetr(@, 'projects')
    @addStandardFacets()

  findBySearch: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || i.get('project_objective').match(term)

  addStandardFacets: ->
    _.each @types, (type) =>
      @facetr.facet(type).desc()

  facets: ->
    @facetr.toJSON()

  addFilter: (facetName, facetValue) =>
    # TODO: Check value if valid for facet
    # Check not a duplicate
    return "Can't add duplicate Facet" if _.findWhere(@filterState, 
      name: facetName
      value: facetValue
    )
    @facetr.facet(facetName).value(facetValue, 'and')
    @addFilterState(facetName, facetValue)

  removeFilter: (facetName, facetValue) =>
    # TODO: Check value if valid for facet
    @facetr.facet(facetName).removeValue(facetValue)
    @removeFilterState(facetName, facetValue)

  addFilterState: (facetName, facetValue) =>
    @filterState.push 
      name: facetName
      value: facetValue
    @trigger 'filters:reset'
    console.log 'added filterState'

  removeFilterState: (facetName, facetValue) =>
    foundFilter = _.findWhere(@filterState, 
      name: facetName
      value: facetValue
    )
    @filterState = _.without(@filterState, foundFilter)
    @trigger 'filters:reset'
    console.log 'removed filterState'

  clearFilters: =>
    @filterState = []
    app.projects.facetr.clearValues()
    @trigger 'filters:reset'
