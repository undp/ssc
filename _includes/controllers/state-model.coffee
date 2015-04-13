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
    @listenTo @, 'change:filterState', @_storeOnChangeEvent
    @listenTo @, 'change:viewState',   @_storeOnChangeEvent
    @listenTo @, 'change:searchTerm',  @_storeOnChangeEvent
    @listenTo @, 'change:projectId',   @_storeOnChangeEvent

    @_store = new StateStore(stateModel: @) # Mixin/Utility class

  attemptRestoreStateFromUrl: (options) ->
    throw 'No options given' unless options?
    fallbackFilter = @_validFallbackFilter(options.action, options.value)
    stateRef = options.stateRef
    return @_restoreFromFallback(fallbackFilter) unless stateRef?
    
    @_store.restore(stateRef)
      .done (stateData) => 
        state = _.extend(stateData, stateRef: stateRef)
        @_restoreFromFound(state)
      .fail => @_restoreFromFallback(fallbackFilter)

  updateUrlForState: ->
    if (projectId = @get('projectId'))
      url = "#/project/#{projectId}"
    else
      primaryFacet = @get('filterState')[0]

      facetName = primaryFacet?.name
      facetValue = primaryFacet?.value
      viewState = @get('viewState')
      stateRef = @get('stateRef')

      url = "#/"
      url = "##{facetName}/#{facetValue}" if facetName? and facetValue?
      url += "?viewState=#{viewState}" if viewState?
      url += "&stateRef=#{stateRef}" if stateRef?

    app.router.navigate(url, trigger: false)

  _storeOnChangeEvent: (eventType, a, b) -> 
    return # TODO: @prod Restore storing functionality
    # Only listens to changes on the 4 principal State attributes
    if @_restoring
      @_restoring = false
      @updateUrlForState()
    else
      stateRef = @_store.store()
      @set('stateRef', stateRef)
      @updateUrlForState()
      @_trackStoreAction(@.toJSON())


  # 
  # MODEL VALIDATION
  # 

  isValidState: (stateToValidate) => 
    # TODO: Change to `validate` and use `isValid` builtin method instead.
    # Currenty operates on an object with StateModel attributes, not a full model.
      if stateToValidate.filterState?.length > 0 || stateToValidate.viewState?
        true
      else
        console.log 'invalid filter state'
        false

  _validFallbackFilter: (action, value) ->
    return false unless action? and value?

    if app.filters.validFilter(action, value)
      fallbackFilter = 
        name: action
        value: value


  # 
  # RESTORE STRATEGIES
  # 

  _restoreFromFound: (foundState) =>
    if @isValidState(foundState)
      @_restoring = true # Avoids change event re-storing state and regenerating stateRef
      @_setState(foundState)
      @_trackRestoreAction(@.toJSON())
    else
      @_resetState()

  _restoreFromFallback: (fallbackFilter) ->
    if fallbackFilter
      @_setFiltersFromArray([fallbackFilter])
    else
      @_resetState()


  # 
  # MANAGE FILTERS
  # These functions are called directly by Views. It's the only place that
  # filters (facets) are added or removed.
  # 

  addFilter: (options) =>
    {facetName, facetValue} = options
    throw "Can't add duplicate Facet" if @_facetAlreadyActive(facetName, facetValue)

    @_addFilterState(facetName, facetValue)
    @collection.addFacet(facetName, facetValue)
    @_trackFilterActions('add', facetName, facetValue) unless options.silent

  removeFilter: (options) ->
    {facetName, facetValue} = options
    throw "Can't remove non-existent Facet" unless @_facetAlreadyActive(facetName, facetValue)
    @_removeFilterState(facetName, facetValue)
    @collection.removeFacet(facetName, facetValue)
    @_trackFilterActions('remove', facetName, facetValue) unless options.silent

  clearFilters: ->
    @set 'filterState', []
    @collection.clearFilters()

  _facetAlreadyActive: (facetName, facetValue) ->
    _.findWhere(@get('filterState'),
      name: facetName
      value: facetValue
    )

  _setFiltersFromArray: (filterArray) ->
    _.each filterArray, (filter) =>
      @_restoring = true
      @addFilter(facetName: filter.name, facetValue: filter.value, silent: true)
    @_restoring = false

  _addFilterState: (facetName, facetValue) ->
    stateClone = _.clone(@get('filterState')) || []
    stateClone.push(
      name: facetName
      value: facetValue
    )
    @set('filterState', stateClone)

  _removeFilterState: (facetName, facetValue) ->
    foundFilter = @_facetAlreadyActive(facetName, facetValue)

    @set('filterState', _.without(@get('filterState'), foundFilter))


  # 
  # MANAGE STATE ATTRIBUTES (other than FILTERS)
  # 

  setViewState: (view) =>
    @set 'viewState', view

  setProjectId: (projectId) =>
    @set 'projectId', projectId

  _setState: (stateObject) ->
    extendState = _.omit(stateObject, ['filterState'])
    state = _.extend(@defaults, extendState)
    @clear(silent:true).set(state, silent: true)
    @_setFiltersFromArray(stateObject.filterState) if stateObject?.filterState.length > 0

  _resetState: (stateObject) =>
    @clear(silent:true).set(@defaults) # TODO: Figure out what calls this reset, and whether it should be silent
    # @clear(silent:true).set(@defaults, silent: true)
    @updateUrlForState()


  # 
  # MIXPANEL TRACKING FILTERS ACTIONS
  # 

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

