class StateStore
  constructor: (options) ->
    throw 'Missing StateModel' unless options?.stateModel
    @state = options.stateModel

  _updateUrl: (options) ->
    {replace} = options

    facetName = @_primaryFacet()?.name
    facetValue = @_primaryFacet()?.value
    viewState = @state.get('viewState')
    stateRef = @state.get('stateRef')

    url = "#/"
    url = "##{facetName}/#{facetValue}" if facetName? and facetValue?
    url += "?viewState=#{viewState}" if facetName?
    url += "&stateRef=#{stateRef}" if stateRef?
    app.router.navigate(url, trigger: false, replace: replace)

  _primaryFacet: ->
    @state.get('filterState')[0]

  # 
  # STORE
  # 
  store: =>
    if @state.get('filterState').length > 0
      stateRef = @_persistState(
        filterState: @state.get('filterState')
        viewState: @state.get('viewState')
      )
      console.log 'Stored at:', stateRef
    else
      stateRef = null

    @state.set('stateRef', stateRef)
    @_updateUrl(replace: true)

  _persistState: (options) -> # Takes stateData, and returns stateRef
    {stateRef, filterState, viewState} = options
    stateRef ?= app.utils.PUID()

    @_saveStateLocal(stateRef: stateRef, filterState: filterState, viewState: viewState)
    @_saveStateRemote(stateRef: stateRef, filterState: filterState, viewState: viewState)
    
    return stateRef

  _saveStateLocal: (options) -> # options = {stateRef, filterState}
    {stateRef, filterState, viewState} = options

    data = 
      filterState: filterState
      viewState: viewState
    localStorage.setItem(stateRef, JSON.stringify(data))
  
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

  # 
  # RETRIEVE
  # 
  retrieve: (options) -> # options = {stateRef, facetName, facetValue, viewState, observedCollection}
    console.warn 'DEV: Retrieving disabled'
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
        @_updateUrl(options)
      )

  _restoreState: (options) -> # options = {stateRef, facetName, facetValue, observedCollection}
    @_restoreFilters(options)
    @_updateUrl(options)

  _restoreFilters: (options) ->
    {filterState, observedCollection} = options
    return 'No filterState provided' unless filterState? 
    return 'No observedCollection provided' unless observedCollection?

    _.each filterState, (filter) =>
      observedCollection.addFilter(name: filter.name, value: filter.value, trigger: false)

  _findLocal: (options) ->
    retrieved = localStorage.getItem(options.stateRef)

    if retrieved?
      return JSON.parse(retrieved)
    else
      return false

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


