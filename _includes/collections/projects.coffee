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
    @listenTo @, 'set', @initFacetr
    @listenTo @, 'filters:add', @storeFilterState
    @listenTo @, 'filters:remove', @storeFilterState
    @filterState = []

  initFacetr: ->
    @facetr = Facetr(@, 'projects')
    @addStandardFacets()

  findBySearch: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || i.get('project_objective').match(term)


  # 
  # Facets
  # 
  addStandardFacets: ->
    _.each @facetTypes, (type) =>
      @facetr.facet(type).desc()

  facets: ->
    @facetr.toJSON()

  addFilter: (options) =>
    {name, value, trigger} = options
    # TODO: Check value if valid for facet
    # Check not a duplicate
    return "Can't add duplicate Facet" if _.findWhere(@filterState, 
      name: name
      value: value
    )
    @facetr.facet(name).value(value, 'and')
    @addFilterState(name, value, trigger)

  addFilterState: (facetName, facetValue, trigger) =>
    @filterState.push 
      name: facetName
      value: facetValue
    @trigger 'filters:add' unless (trigger? and !trigger)

  removeFilter: (options) =>
    {name, value, trigger} = options
    # TODO: Check value if valid for facet
    @facetr.facet(name).removeValue(value)
    @removeFilterState(name, value, trigger)

  removeFilterState: (facetName, facetValue, trigger) =>
    foundFilter = _.findWhere(@filterState, 
      name: facetName
      value: facetValue
    )
    @filterState = _.without(@filterState, foundFilter)
    @trigger 'filters:remove' unless (trigger? and !trigger)

  clearFilters: =>
    @filterState = []
    app.projects.facetr.clearValues()
    @trigger 'filters:reset'


  # 
  # Serialize FilterState
  # 
  storeFilterState: ->
    return app.router.updateUrlForState() if @filterState.length is 0
    hashState = @filterState[0] # First filter set
    filterRef = @serializeFilters() 
    app.router.updateUrlForState(hashState.name, hashState.value, filterRef)

  serializeFilters: ->
    filterRef = app.utils.uuid()
    stringifiedFilters = JSON.stringify(@filterState)
    localStorage.setItem(filterRef, stringifiedFilters)
    @postRemoteFilterState(filterRef)
    filterRef

  restoreFilterStateFromId: (filterRef, fallbackFacetName, fallbackFacetValue) ->
    # if (found = localStorage.getItem(filterRef))?
    #   name = JSON.parse(found)[0].name
    #   value = JSON.parse(found)[0].value
    #   app.router.updateUrlForState(name, value, filterRef)
    # else
    @getRemoteFilterState(
      filterRef: filterRef
      success: (data) => 
        retrievedFilterObject = data.results?[0]
        @restoreFilters(filterRef, retrievedFilterObject)
      fail: -> app.router.updateUrlForState(fallbackFacetName, fallbackFacetValue)
    )

  restoreFilters: (filterRef, filterObject) ->
    _.each filterObject.filterState, (filter) =>
      @addFilter(name: filter.name, value: filter.value, trigger: false)


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
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("Failed posting filterState")
    )

  getRemoteFilterState: (options) ->
    $.ajax(
      url: "https://api.parse.com/1/classes/filterState"
      type: "GET"
      data:
        "where":"{\"filterRef\":\"" + options.filterRef + "\"}"
      headers:
        "X-Parse-REST-API-Key":"h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W"
        "X-Parse-Application-Id":"vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO"
      success: (data, textStatus, jqXHR) ->
        options.success(data)
      error: (jqXHR, textStatus, errorThrown) ->
        options.fail()
    )
