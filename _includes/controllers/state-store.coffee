API_KEY            = app.config.parse.apiKey
APP_ID             = app.config.parse.appID
API_URL            = app.config.parse.apiURL

# 
# Attached to StateModel to facilitate persisting of state to local 
# and remote stores
# 
class StateStore
  constructor: (options) ->
    throw 'Missing StateModel' unless options?.stateModel
    @state = options.stateModel
    @_throttledStateSaveRemote = _.throttle(@_saveStateRemote, 2000)

  # 
  # STORE
  # 
  store: => # Stores a `StateModel`, returns a stateRef
    if @state.isValidState(@state.toJSON())
      stateRef = @_persistState(
        filterState: @state.get('filterState')
        viewState: @state.get('viewState')
      )
    else
      stateRef = null

    return stateRef

  _persistState: (options) -> # Takes stateData, and returns stateRef
    {stateRef, filterState, viewState} = options
    stateRef ?= app.utils.PUID()

    @_saveStateLocal(stateRef: stateRef, filterState: filterState, viewState: viewState)

    @_throttledStateSaveRemote(stateRef: stateRef, filterState: filterState, viewState: viewState)
    
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
  restore: (stateRef) => # Retores a StateModel from a `stateRef` 
    new Promise( (resolve, reject) =>
      if foundLocal = @_findLocal(stateRef)
        resolve(foundLocal)
      else
        @_findRemote(stateRef, deferred)
    )

  _findLocal: (stateRef) ->
    retrieved = localStorage.getItem(stateRef)

    if retrieved
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


