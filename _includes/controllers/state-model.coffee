API_KEY            = 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
APP_ID             = 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
API_URL            = 'https://api.parse.com/1/classes/stateData'
INITIAL_VIEW_STATE = 'map' # TODO: @prod Ensure this is 'map'

# 
# SERIALIZE and STORE state
# 

class StateModel extends Backbone.Model
  defaults:
    filterState : []
    viewState   : INITIAL_VIEW_STATE
    searchTerm  : null
    projectId   : null

  initialize: ->
    @listenTo @, 'all', @_storeOnChangeEvent
    @_store = new StateStore(stateModel: @) # Mixin/Utility class

  _isValid: (state) -> # Receive object
    if state.filterState?.length > 0 # TODO: Add a tiny bit more logic here.
      true
    else
      false

  _storeOnChangeEvent: (eventType, a, b) ->
    if @_restoring
      @_restoring = false
      @_store.updateUrl()
    else
      @_store.store() if (/change\:(viewState|filterState|searchTerm|projectId)/).test(eventType)
      @_trackStoreAction(@.toJSON())

  restoreStateFromUrl: (options) ->
    throw 'No options given' unless options?
    fallbackFilter = @_validFallbackFilter(options.fallbackAction, options.fallbackValue)
    stateRef = options.stateRef

    if stateRef?
      @_store.restore(stateRef) # Returns a promise
      .then (stateData) => 
        @_restoreFromFound(_.extend(stateData, stateRef: stateRef))
      .fail => @_restoreFromFallback(fallbackFilter)
    else if fallbackFilter
      @_restoreFromFallback(fallbackFilter)
    else
      @_resetState()
  # 
  # Strategies for restoring State 
  # 
  _restoreFromFound: (foundState) =>
    if @_isValid(foundState)
      @_restoring = true # Avoids change event re-storing state and regenerating stateRef
      @_setState(foundState)
      @_trackRestoreAction(@.toJSON())
    else
      @_resetState()

  _restoreFromFallback: (fallbackFilter) ->
    @_setFilters([fallbackFilter])

  _validFallbackFilter: (action, value) ->
    return false unless action? and value?

    if app.filters.validFilter(action, value)
      fallbackFilter = 
        name: action
        value: value

  # 
  # MANAGE STATE ATTRIBUTES (other than FILTERS)
  # 
  setContentView: (view) =>
    @set 'viewState', view

  setProjectShowId: (projectId) =>
    @set 'projectId', projectId

  _setState: (stateObject) ->
    extendState = _.omit(stateObject, ['filterState'])
    state = _.extend(@defaults, extendState)
    @clear(silent:true).set(state, silent: true)
    @_setFilters(stateObject.filterState) if stateObject?.filterState.length > 0

  _resetState: (stateObject) =>
    @clear(silent:true).set(@defaults)

  # 
  # MANAGE FILTERS
  # 
  _setFilters: (filterArray) ->
    _.each filterArray, (filter) =>
      @addFilter(facetName: filter.name, facetValue: filter.value, trigger: false)

  clearFilters: ->
    @set 'filterState', []
    @collection.clearFilters()

  addFilter: (options) =>
    {facetName, facetValue} = options
    trigger = options.trigger if options.trigger? || true
    throw "Can't add duplicate Facet" if @_facetAlreadyActive(facetName, facetValue)
    @_addFilterState(facetName, facetValue)
    @collection.addFilter(facetName, facetValue, trigger)
    @_trackFilterActions('add', facetName, facetValue) if trigger

  _addFilterState: (facetName, facetValue, trigger) ->
    stateClone = _.clone(@get('filterState')) || []
    stateClone.push(
      name: facetName
      value: facetValue
    )
    @set('filterState', stateClone, silent: !!trigger)

  removeFilter: (options) ->
    {facetName, facetValue} = options
    trigger = options.trigger? || true
    throw "Can't remove non-existent Facet" unless @_facetAlreadyActive(facetName, facetValue)
    @_removeFilterState(facetName, facetValue)
    @collection.removeFilter(facetName, facetValue)

    @_trackFilterActions('remove', facetName, facetValue) if trigger

  _removeFilterState: (facetName, facetValue) ->
    foundFilter = @_facetAlreadyActive(facetName, facetValue)

    @set('filterState', _.without(@get('filterState'), foundFilter))

  _facetAlreadyActive: (facetName, facetValue) ->
    _.findWhere(@get('filterState'),
      name: facetName
      value: facetValue
    )

  _trackFilterActions: (action, facetName, facetValue) ->
    if action is 'add' and @get('filterState').length == 1
      filterType = 'primary filter'
    else if action is 'add'
      filterType = 'secondary filter'
    else
      filterType = 'any filter'

    mixpanel.track('filterAction',
      'action': action
      'filterName': facetName,
      'filterValue': facetValue
      'filterType': filterType
    )

  _trackStoreAction: (state) ->
    mixpanel.track('filterStore',
      'action': 'store'
      'filtersLength': state.filterState.length
    )

  _trackRestoreAction: (state) ->
    mixpanel.track('filterStore',
      'action': 'retrieve'
      'filtersLength': state.filterState.length
    )

