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
    @listenTo @, 'filters:add', @serialiseFilterRoute
    @listenTo @, 'filters:remove', @serialiseFilterRoute
    @filterState = []

  initFacetr: ->
    @facetr = Facetr(@, 'projects')
    @addStandardFacets()

  findBySearch: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || i.get('project_objective').match(term)

  # 
  # FACETS
  # 
  
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

  addFilterState: (facetName, facetValue) =>
    @filterState.push 
      name: facetName
      value: facetValue
    @trigger 'filters:add'

  removeFilter: (facetName, facetValue) =>
    # TODO: Check value if valid for facet
    @facetr.facet(facetName).removeValue(facetValue)
    @removeFilterState(facetName, facetValue)

  removeFilterState: (facetName, facetValue) =>
    foundFilter = _.findWhere(@filterState, 
      name: facetName
      value: facetValue
    )
    @filterState = _.without(@filterState, foundFilter)
    @trigger 'filters:remove'

  clearFilters: =>
    @filterState = []
    app.projects.facetr.clearValues()
    @trigger 'filters:reset'


  # 
  # Serialize Filters
  # 
  serialiseFilterRoute: ->
    return @setUrl() if @filterState.length is 0
    hashState = @filterState[0]
    filterRef = @serializeFilters() 
    @setUrl(hashState.name, hashState.value, filterRef)

  setUrl: (facetName, facetValue, filterRef) ->
    url = ""
    url = "#{facetName}/#{facetValue}" if facetName? and facetValue?
    url += "?filterRef=#{filterRef}" if filterRef?
    console.log "Setting URL for #{facetName}: #{facetValue} and filterRef: #{filterRef}"
    app.router.navigate(url)

  serializeFilters: ->
    uuid = app.utils.uuid()
    stringifiedFilters = JSON.stringify(@filterState)
    localStorage.setItem(uuid, stringifiedFilters)
    uuid # Return `filterRef`
    # @postToRemoteService(uuid, stringifiedFilters)

  retrieveFiltersFromId: (filterRef, fallbackFacetName, fallbackFacetValue) ->
    if (found = localStorage.getItem(filterRef))?
      # @tryGetRemote()
      name = JSON.parse(found)[0].name
      value = JSON.parse(found)[0].value
      @setUrl(name, value, filterRef)
    else
      @setUrl(facetName, facetValue)
