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
    @listenTo @, 'set', @initFacetr
    @listenTo @, 'filters:add', @storeState
    @listenTo @, 'filters:remove', @storeState
    @resetState()

  resetState: ->
    @filterState = [] # TODO: Probably move from this Collection to a ViewModel
    @viewState = INITIAL_VIEW_STATE # TODO: Definitely move from this Collection to a ViewModel

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
    @resetState()
    @facetr.clearValues()
    @storeState()


  # 
  # SERIALIZE and STORE filterState
  # 
  storeState: -> # Listens to 'filter:add' and 'filter:remove' events
    return @rebuildURL() if @filterState.length is 0
    primaryFilter = _.first(@filterState)
    stateRef = @saveState(
      filterState: @filterState
      viewState: @viewState
    ) 

    @rebuildURL(stateRef: stateRef, facetName: primaryFilter.name, facetValue: primaryFilter.value)

  saveState: (options) -> # Takes stateData, and returns stateRef
    console.dir(options)
    {stateRef, filterState, viewState} = options
    stateRef ?= app.utils.PUID()

    @saveStateLocal(stateRef: stateRef, filterState: filterState, viewState: viewState)
    @saveStateRemote(stateRef: stateRef, filterState: filterState, viewState: viewState)
    
    return stateRef

  # 
  # RETRIEVE and RESTORE filterState
  # 

  retrieveStateData: (options) -> # options = {stateRef, facetName, facetValue}
    {stateRef, facetName, facetValue} = options

    unless app.utils.validPUID(stateRef)
      options.stateRef = null
      options.stateRef = @saveState(options) # Pass null stateRef, saveState returns new ref
      @rebuildURL(options)

    # Search locally
    if (retrievedData = @findLocal(options))
      options.filterState = retrievedData.filterState
      options.viewState = retrievedData.viewState
      @restoreState(options)
    else # Else search remote
      deferred = $.Deferred()

      @getRemoteFilterState(
        stateRef: stateRef
        deferred: deferred
      ).done( (retrievedData) =>
        options.filterState = retrievedData.filterState
        options.viewState = retrievedData.viewState
        @saveStateLocal(options)
        @restoreState(options)
      ).fail( => 
        console.info 'Failed to retrieve filterState from remote service'
        options.stateRef = null
        @rebuildURL(options)
      )


  findLocal: (options) ->
    retrieved = localStorage.getItem(options.stateRef)

    if retrieved?
      return JSON.parse(retrieved)
    else
      return false

  # 
  # Recreate state and rebuild URL
  # 
  restoreState: (options) -> # options = {stateRef, facetName, facetvalue}
    @restoreFilters(options.filterState)
    @restoreView(options.viewState)
    @rebuildURL(options)

  restoreFilters: (filterState) ->
    return 'No filterState given' unless filterState?

    _.each filterState, (filter) =>
      @addFilter(name: filter.name, value: filter.value, trigger: false)
    @trigger 'filters:reset'    

  restoreView: (viewState) ->
    console.log "Please render: #{viewState} view"

  rebuildURL: (options) -> # options = {stateRef, facetName, facetValue, viewState}
    return app.router.navigate() if !options?

    {stateRef, facetName, facetValue, viewState} = options
    viewState ?= INITIAL_VIEW_STATE

    url = ""
    url = "#{facetName}/#{facetValue}" if facetName? and facetValue?
    url += "?viewState=#{viewState}"
    url += "&stateRef=#{stateRef}" if stateRef?
    app.router.navigate(url)

  # 
  # FilterState stores
  # 

  saveStateLocal: (options) -> # options = {stateRef, filterState}
    {stateRef, filterState, viewState} = options

    data = 
      filterState: filterState
      viewState: viewState
    localStorage.setItem(stateRef, JSON.stringify(data))
  
  # Takes stateRef and filterState
  # Succeeds/fails without needing to inform user
  saveStateRemote: (options) => # options = {stateRef, filterState}
    {stateRef, filterState, viewState} = options

    data = JSON.stringify 
      stateRef: stateRef
      filterState: filterState
      viewState: viewState
    $.ajax(
      url: API_URL
      type: 'POST'
      data: data
      headers:
        'X-Parse-REST-API-Key': API_KEY
        'X-Parse-Application-Id': APP_ID
        "Content-Type":"application/json"
      success: (data, textStatus, jqXHR) ->
        console.info("Posted filterState to remote store for stateRef: ", stateRef)
      error: (jqXHR, textStatus, errorThrown) ->
        console.info("Posting filterState to remote store unsuccessful")
    )

  # Takes stateRef. 
  # Resolves with first filterState
  getRemoteFilterState: (options) -> # options = {stateRef, deferred}
    {stateRef, deferred} = options

    $.ajax(
      url: API_URL
      type: "GET"
      data:
        "where":"{\"stateRef\":\"" + stateRef + "\"}"
      headers:
        "X-Parse-REST-API-Key": API_KEY
        "X-Parse-Application-Id": APP_ID
      success: (data, textStatus, jqXHR) ->
        if data.results? and data.results.length > 0
          retrieved = data.results[0]
          deferred.resolve(retrieved)
        else
          deferred.reject()
      error: (jqXHR, textStatus, errorThrown) ->
        deferred.reject()
    )

    return deferred.promise()

