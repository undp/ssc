class StateStore
  constructor: (options) ->
    throw 'Missing StateModel' unless options?.stateModel
    @state = options.stateModel

  updateUrl: ->
    facetName = @_primaryFacet()?.name
    facetValue = @_primaryFacet()?.value
    viewState = @state.get('viewState')
    stateRef = @state.get('stateRef')

    url = "#/"
    url = "##{facetName}/#{facetValue}" if facetName? and facetValue?
    url += "?viewState=#{viewState}" if facetName?
    url += "&stateRef=#{stateRef}" if stateRef?
    app.router.navigate(url, trigger: false)

  _primaryFacet: ->
    @state.get('filterState')[0]

  # 
  # STORE
  # 
  store: =>
    # TODO: Check if state has changed since last store - or whether it's being restored, and stateRef probably shouldn't change
    if @state.get('filterState').length > 0 and @state.isValid(@state.toJSON())
      stateRef = @_persistState(
        filterState: @state.get('filterState')
        viewState: @state.get('viewState')
      )
    else
      stateRef = null

    @state.set('stateRef', stateRef, trigger: false) # Don't update state on save?
    @updateUrl()

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
  restore: (stateRef) =>
    return false unless stateRef?
    deferred = $.Deferred()

    foundLocal = @_findLocal(stateRef)

    if foundLocal? 
      deferred.resolve(foundLocal) 
    else
      @_findRemote(stateRef, deferred)

    deferred.promise()

  _findLocal: (stateRef) ->
    retrieved = localStorage.getItem(stateRef)

    if retrieved?
      return JSON.parse(retrieved)
    else
      return false

  _findRemote: (stateRef, deferred) ->
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


