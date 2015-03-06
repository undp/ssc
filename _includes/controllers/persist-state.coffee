class PersistState

  storeStateData: (stateObject) -> # Listens to 'filter:add' and 'filter:remove' events
    return @_rebuildURL() unless stateObject? and stateObject.filterState.length isnt 0
    primaryFilter = _.first(stateObject.filterState)
    stateRef = @_persistState(
      filterState: stateObject.filterState
      viewState: stateObject.viewState
    ) 

    @_rebuildURL(stateRef: stateRef, facetName: primaryFilter.name, facetValue: primaryFilter.value)

  retrieveStateData: (options) -> # options = {stateRef, facetName, facetValue, viewState}
    {stateRef, facetName, facetValue, viewState} = options

    unless app.utils.validPUID(stateRef)
      options.stateRef = null
      options.filterState = [name: facetName, value: facetValue]

      newStateRef = @_persistState(options) # Pass null stateRef, _persistState returns new ref
      options.stateRef = newStateRef
      options.viewState ?= INITIAL_VIEW_STATE

      @_restoreState(options)

    # Search locally
    if (retrievedData = @_findLocal(options))
      options.filterState = retrievedData.filterState
      options.viewState = retrievedData.viewState
      @_restoreState(options)
    else # Else search remote
      deferred = $.Deferred()

      @_getRemoteFilterState(
        stateRef: stateRef
        deferred: deferred
      ).done( (retrievedData) =>
        options.filterState = retrievedData.filterState
        options.viewState = retrievedData.viewState
        @_saveStateLocal(options)
        @_restoreState(options)
      ).fail( => 
        console.info 'Failed to retrieve filterState from remote service'
        options.stateRef = null
        @_rebuildURL(options)
      )

  _persistState: (options) -> # Takes stateData, and returns stateRef
    {stateRef, filterState, viewState} = options
    stateRef ?= app.utils.PUID()

    @_saveStateLocal(stateRef: stateRef, filterState: filterState, viewState: viewState)
    @_saveStateRemote(stateRef: stateRef, filterState: filterState, viewState: viewState)
    
    return stateRef

  _findLocal: (options) ->
    retrieved = localStorage.getItem(options.stateRef)

    if retrieved?
      return JSON.parse(retrieved)
    else
      return false

  # 
  # Recreate state and rebuild URL
  # 
  _restoreState: (options) -> # options = {stateRef, facetName, facetValue}
    @_restoreFilters(options.filterState)
    @_rebuildURL(options)

  _restoreFilters: (filterState) ->
    return 'No filterState given' unless filterState?

    _.each filterState, (filter) =>
      console.error 'Rebuilding filters - need access to collection'
      # @observedCollection.addFilter(name: filter.name, value: filter.value, trigger: false)
    @trigger 'filters:reset'    

  _rebuildURL: (options) -> # options = {stateRef, facetName, facetValue, viewState}
    return app.router.navigate() if !options?

    {stateRef, facetName, facetValue, viewState} = options
    viewState  ?= INITIAL_VIEW_STATE

    url = ""
    url = "#{facetName}/#{facetValue}" if facetName? and facetValue?
    url += "?viewState=#{viewState}"
    url += "&stateRef=#{stateRef}" if stateRef?
    app.router.navigate(url)

  # 
  # FilterState stores
  # 

  _saveStateLocal: (options) -> # options = {stateRef, filterState}
    {stateRef, filterState, viewState} = options

    data = 
      filterState: filterState
      viewState: viewState
    localStorage.setItem(stateRef, JSON.stringify(data))
  
  # Takes stateRef and filterState
  # Succeeds/fails without needing to inform user
  _saveStateRemote: (options) => # options = {stateRef, filterState}
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
  _getRemoteFilterState: (options) -> # options = {stateRef, deferred}
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

