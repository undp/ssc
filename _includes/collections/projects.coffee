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
    app.router.navigate(url)

  serializeFilters: ->
    filterRef = app.utils.uuid()
    stringifiedFilters = JSON.stringify(@filterState)
    localStorage.setItem(filterRef, stringifiedFilters)
    @postRemoteFilterState(filterRef)
    filterRef

  retrieveFiltersFromId: (filterRef, fallbackFacetName, fallbackFacetValue) ->
    if (found = localStorage.getItem(filterRef))?
      @getRemoteFilterState(filterRef)
      name = JSON.parse(found)[0].name
      value = JSON.parse(found)[0].value
      @setUrl(name, value, filterRef)
    else
      @setUrl(fallbackFacetName, fallbackFacetValue)

  # 
  # Remote filterState store
  # 
  postRemoteFilterState: (filterRef) =>
    data = 
      filterRef: filterRef
      filterState: @filterState
    
    $.ajax(
      url: 'https://api.parse.com/1/classes/filterState'
      type: 'POST'
      data: JSON.stringify(data)
      headers:
        'X-Parse-REST-API-Key': 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
        'X-Parse-Application-Id': 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
        "Content-Type":"application/json"
      success: (data, textStatus, jqXHR) ->
        console.log("POST HTTP Request Succeeded: " + jqXHR.status);
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("POST HTTP Request Failed")
    )

  getRemoteFilterState: (filterRef, deferred) ->
    $.ajax(
      url: "https://api.parse.com/1/classes/filterState"
      type: "GET"
      data:
        "where":"{\"filterRef\":\"" + filterRef + "\"}"
      headers:
        "X-Parse-REST-API-Key":"h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W"
        "X-Parse-Application-Id":"vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO"
      success: (data, textStatus, jqXHR) ->
        console.log("GET HTTP Request Succeeded: " + jqXHR.status)
        console.dir(data.results[0])
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("GET HTTP Request Failed")
    )
