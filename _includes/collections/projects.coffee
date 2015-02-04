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

  # anyFacetSelected: ->
  #   @selectedFacets().length > 0

  # selectedFacets: ->
  #   _.chain(@facetr.facets())
  #     .filter( (facet) -> facet.isSelected() )
  #     .map( (facet) -> facet.toJSON().data.name )
  #     .value()

  facets: ->
    @facetr.toJSON()

  addFilter: (facetName, facetValue) =>
    # TODO: Check value if valid for facet
    @facetr.facet(facetName).value(facetValue)
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
