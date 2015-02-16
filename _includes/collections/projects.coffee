API_KEY = 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
APP_ID  = 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
API_URL = 'https://api.parse.com/1/classes/filterState'


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

  facets: -> # @facetr.toJSON()
    @facetr.toJSON()

  addFilter: (options) =>
    {name, value, trigger} = options

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
    @trigger 'filters:add' unless (trigger? and !trigger)

  removeFilter: (options) =>
    {name, value, trigger} = options
    # TODO: Check value if valid for facet
    @facetr.facet(name).removeValue(value)
    @removeFilterState(name, value, trigger)

  removeFilterState: (facetName, facetValue, trigger) => # Triggers filters:remove
    foundFilter = _.findWhere(@filterState, 
      name: facetName
      value: facetValue
    )
    @filterState = _.without(@filterState, foundFilter)
    @trigger 'filters:remove' unless (trigger? and !trigger)

  clearFilters: => # Triggers filters:reset 
    @filterState = []
    app.projects.facetr.clearValues()
    @trigger 'filters:reset'


  # 
  # SERIALIZE filterState
  # 
  storeFilterState: -> # Listens to 'filter:add' and 'filter:remove' events
    return app.router.updateUrlForState() if @filterState.length is 0
    hashState = @filterState[0] # First filter set
    filterRef = @serializeFilters(@filterState) 

    app.router.updateUrlForState(filterRef: filterRef, facetName: hashState.name, facetValue: hashState.value)

  serializeFilters: (filterState) -> # Takes filterState, and returns filterRef
    filterRef = app.utils.uuid()

    localStorage.setItem(filterRef, JSON.stringify(filterState))
    @postRemoteFilterState(filterRef, filterState)
    
    return filterRef

  # 
  # RETRIEVE and RESTORE filterState
  # 
  recreateFilterStateFromRef: (options) -> # options = {filterRef, fallbackName, fallbackValue}
    {filterRef, fallbackName, fallbackValue} = options
    return "No filterRef given" unless filterRef

    if localStorageResponse = @retrieveStateFromLocalStorage(options)
      @rebuildFilterStateFromStoreResponse(localStorageResponse)
      console.log 'retrieveStateFromLocalStorage successful'
    else
    # 2. retrieveStateFromRemoteStorage
      console.log 'need to try alternative restore strategy'
    # 3. Reset based on fallbackFacetName and fallbackFacetValue

  retrieveStateFromLocalStorage: (options) ->
    return unless filterRef = options.filterRef

    if found = localStorage.getItem(filterRef)
      name: JSON.parse(found)[0].name
      value: JSON.parse(found)[0].value

  retrieveStateFromRemoteStorage: (options) ->
    {filterRef, fallbackFacetName, fallbackFacetValue} = options

    @getRemoteFilterState
      filterRef: filterRef
      successCallback: (data) => 
        @rebuildFilterStateFromStoreResponse(data.results?[0]) 
      failCallback: -> app.router.updateUrlForState(facetName: fallbackFacetName, facetValue: fallbackFacetValue)

  rebuildFilterStateFromStoreResponse: (filterRef, data) ->
    if retrievedFilterObject?.length == 0
      app.router.updateUrlForState(facetName: fallbackFacetName, facetValue: fallbackFacetValue)
    else
      @restoreFilter(retrievedFilterObject)

    app.router.updateUrlForState(filterRef: filterRef, facetName: name, facetValue: value)

  restoreFilter: (options) ->
    _.each options.filterState, (filter) =>
      @addFilter(name: filter.name, value: filter.value, trigger: false)
    @trigger 'filters:reset'    


  # 
  # Remote filterState store
  # 
  postRemoteFilterState: (options) => # options = {filterRef, filterState}
    {filterRef, filterState} = options

    data = 
      filterRef: filterRef
      filterState: filterState
    
    $.ajax(
      url: API_URL
      type: 'POST'
      data: JSON.stringify(data)
      headers:
        'X-Parse-REST-API-Key': API_KEY
        'X-Parse-Application-Id': APP_ID
        "Content-Type":"application/json"
      error: (jqXHR, textStatus, errorThrown) ->
        console.info("Failed posting filterState to remote store")
    )

  getRemoteFilterState: (options) -> # options = {filterRef, successCallback, failCallback}
    {filterRef, successCallback, failCallback} = options

    $.ajax(
      url: API_URL
      type: "GET"
      data:
        "where":"{\"filterRef\":\"" + filterRef + "\"}"
      headers:
        "X-Parse-REST-API-Key": API_KEY
        "X-Parse-Application-Id": APP_ID
      success: (data, textStatus, jqXHR) ->
        successCallback(data)
      error: (jqXHR, textStatus, errorThrown) ->
        failCallback()
    )
