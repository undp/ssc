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
    @viewState = ''

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
    unless (trigger? and !trigger)
      console.log 'trigger filters:remove'
      @trigger 'filters:remove'

  clearFilters: => # Triggers filters:reset 
    @filterState = []
    @facetr.clearValues()
    @storeFilterState()


  # 
  # SERIALIZE and STORE filterState
  # 
  storeFilterState: -> # Listens to 'filter:add' and 'filter:remove' events
    return @replaceUrlForState() if @filterState.length is 0
    hashState = _.first(@filterState)
    filterRef = @serializeFilters(@filterState) 
    viewState = @viewState

    @replaceUrlForState(filterRef: filterRef, facetName: hashState.name, facetValue: hashState.value)

  serializeFilters: (filterState) -> # Takes filterState, and returns filterRef
    filterRef = app.utils.UUID()

    @postLocalFilterState(filterRef: filterRef, filterState: filterState)
    @postRemoteFilterState(filterRef: filterRef, filterState: filterState)
    
    return filterRef

  # 
  # RETRIEVE and RESTORE filterState
  # 

  recreateFilterStateFromRef: (options) -> # options = {filterRef, facetName, facetValue}
    {filterRef, facetName, facetValue} = options
    return 'Invalid UUID' unless app.utils.validUUID(filterRef)

    # see if local can return something useful
    if (retrieved = @retrieveStateFromLocalStorage(options))
      options.filterState = retrieved
      @restoreStateFromStore(options)
    else # Check remote - if that fails then fallback
      console.log 'not found local'
      failCallback: =>
        console.log 'Not found remote: using fallbackFacetName and fallbackFacetValue'

      # @restoreStateFromStore(options)
      # options = 
      #   filterRef: null
      #   facetName: facetName
      #   facetValue: facetValue
      # @replaceUrlForState(options)
      # success: restoreStateFromStore, update Url
    # if not, then try remote
      # success: restoreState, update Url
    # if neither, then
      # just use facetValue and facetName

  retrieveStateFromLocalStorage: (options) ->
    return 'No filterRef given' unless filterRef = options.filterRef

    retrieved = localStorage.getItem(filterRef)

    if retrieved?
      return JSON.parse(retrieved)
    else
      return false

  restoreStateFromStore: (options) -> # options = {filterRef, name, value, filterState}
    @restoreFilterState(options)
    @replaceUrlForState(options)

  # recreateFilterStateFromRef: (options) -> # options = {filterRef, facetName, facetValue}
  #   {filterRef, facetName, facetValue} = options
  #   return "No filterRef given" unless filterRef

  #   if localStorageResponse = @retrieveStateFromLocalStorage(options)
  #     @rebuildFilterStateFromStoreResponse(localStorageResponse)
  #     console.log 'retrieveStateFromLocalStorage successful'
  #   else
  #   # 2. retrieveStateFromRemoteStorage
  #     console.log 'need to try alternative restore strategy'
  #   # 3. Reset based on fallbackFacetName and fallbackFacetValue

  # retrieveStateFromLocalStorage: (options) ->
  #   return unless filterRef = options.filterRef

  #   if found = localStorage.getItem(filterRef)
  #     name: JSON.parse(found)[0].name
  #     value: JSON.parse(found)[0].value

  # retrieveStateFromRemoteStorage: (options) ->
  #   {filterRef, fallbackFacetName, fallbackFacetValue} = options

  #   @getRemoteFilterState
  #     filterRef: filterRef
  #     successCallback: (data) => 
  #       @rebuildFilterStateFromStoreResponse(data.results?[0]) 
  #     failCallback: -> @replaceUrlForState(facetName: fallbackFacetName, facetValue: fallbackFacetValue)

  # rebuildFilterStateFromStoreResponse: (filterRef, data) ->
  #   if retrievedFilterObject?.length == 0
  #     @replaceUrlForState(facetName: fallbackFacetName, facetValue: fallbackFacetValue)
  #   else
  #     @restoreFilter(retrievedFilterObject)

  #   @replaceUrlForState(filterRef: filterRef, facetName: name, facetValue: value)

  restoreFilterState: (options) ->
    return 'No filterState given' unless options.filterState?

    _.each options.filterState, (filter) =>
      @addFilter(name: filter.name, value: filter.value, trigger: false)
    @trigger 'filters:reset'    

  replaceUrlForState: (options) -> # options = {filterRef, facetName, facetValue}
    return app.router.navigate() if !options?

    {filterRef, facetName, facetValue} = options
    url = ""
    url = "#{facetName}/#{facetValue}" if facetName? and facetValue?
    url += "?filterRef=#{filterRef}" if filterRef?
    app.router.navigate(url)

  # 
  # FilterState stores
  # 

  postLocalFilterState: (options) -> # options = {filterRef, filterState}
    {filterRef, filterState} = options

    state = JSON.stringify(filterState)
    localStorage.setItem(filterRef, state)
  
  postRemoteFilterState: (options) => # options = {filterRef, filterState}
    {filterRef, filterState} = options

    data = JSON.stringify 
      filterRef: filterRef
      filterState: filterState

    $.ajax(
      url: API_URL
      type: 'POST'
      data: data
      headers:
        'X-Parse-REST-API-Key': API_KEY
        'X-Parse-Application-Id': APP_ID
        "Content-Type":"application/json"
      success: (data, textStatus, jqXHR) ->
        console.info("Posted filterState to remote store for filterRef: ", filterRef)
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
