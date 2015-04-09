API_KEY            = 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
APP_ID             = 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
API_URL            = 'https://api.parse.com/1/classes/stateData'
INITIAL_VIEW_STATE = 'list' # TODO: @prod Ensure this is 'map'

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

  updateUrl: ->
    if (viewingId = @get('projectId'))
      url = "#/project/#{viewingId}"
    else
      primaryFacet = @_primaryFacet()

      facetName = primaryFacet?.name
      facetValue = primaryFacet?.value
      viewState = @get('viewState')
      stateRef = @get('stateRef')

      url = "#/"
      url = "##{facetName}/#{facetValue}" if facetName? and facetValue?
      url += "?viewState=#{viewState}" if viewState?
      url += "&stateRef=#{stateRef}" if stateRef?

    app.router.navigate(url, trigger: false)

  _isValid: (state) -> # Receive object
    if state.filterState?.length > 0 || state.viewState? # TODO: Add a tiny bit more logic here.
      true
    else
      console.log 'invalid filter state'
      false

  _storeOnChangeEvent: (eventType, a, b) ->
    if @_restoring
      @_restoring = false
      @updateUrl()
    else
      @_store.store() if (/change\:(viewState|filterState|searchTerm|projectId)/).test(eventType)
      @_trackStoreAction(@.toJSON())

  _primaryFacet: ->
    @get('filterState')[0]

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
    @clear(silent:true).set(@defaults) # TODO: Figure out what calls this reset, and whether it should be silent
    # @clear(silent:true).set(@defaults, silent: true)
    @updateUrl()

  # 
  # MANAGE FILTERS
  # 
  _setFilters: (filterArray) ->
    _.each filterArray, (filter) =>
      @_restoring = true
      @addFilter(facetName: filter.name, facetValue: filter.value, silent: true)
    @_restoring = false

  clearFilters: ->
    @set 'filterState', []
    @collection.clearFilters()

  addFilter: (options) =>
    {facetName, facetValue} = options
    throw "Can't add duplicate Facet" if @_facetAlreadyActive(facetName, facetValue)

    @_addFilterState(facetName, facetValue)
    @collection.addFacet(facetName, facetValue)
    @_trackFilterActions('add', facetName, facetValue) unless options.silent

  _addFilterState: (facetName, facetValue) ->
    stateClone = _.clone(@get('filterState')) || []
    stateClone.push(
      name: facetName
      value: facetValue
    )
    @set('filterState', stateClone)

  removeFilter: (options) ->
    {facetName, facetValue} = options
    throw "Can't remove non-existent Facet" unless @_facetAlreadyActive(facetName, facetValue)
    @_removeFilterState(facetName, facetValue)
    @collection.removeFacet(facetName, facetValue)
    @_trackFilterActions('remove', facetName, facetValue) unless options.silent

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

