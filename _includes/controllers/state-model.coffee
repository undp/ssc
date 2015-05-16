INITIAL_VIEW_STATE = app.config.initialViewState

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
    # @listenTo @, 'change:projectId',   @_storeOnChangeEvent

    @_store = new StateStore(stateModel: @) # Mixin/Utility class

  attemptRestoreStateFromUrl: (options) ->
    throw 'No options given' unless options?
    fallbackFilter = @_validFallbackFilter(options.action, options.value)
    stateRef = options.stateRef
    return @_restoreFromFallback(fallbackFilter, stateRef) unless stateRef?
    
    @_store.restore(stateRef)
      .done (stateData) => 
        state = _.extend(stateData, stateRef: stateRef)
        @_restoreFromFound(state)
      .fail => @_restoreFromFallback(fallbackFilter, stateRef)

  _updateUrlForState: ->
    if (projectId = @get('projectId'))
      url = "#/project/#{projectId}"
    else
      primaryFacet = @get('filterState')[0]

      facetName = primaryFacet?.name
      facetValue = primaryFacet?.value
      viewState = @get('viewState')
      stateRef = @get('stateRef')

      url = "#"
      url = "##{facetName}/#{facetValue}" if facetName? and facetValue?
      url += "?viewState=#{viewState}" if viewState?
      url += "&stateRef=#{stateRef}" if stateRef?

    @_trackUrl(url)
    app.router.navigate(url)

  _storeOnChangeEvent: (eventType, object) -> 
    # See listeners above, only responds to changes on the 4 principal State
    # attributes
    if @_restoring
      @_restoring = false
      @_updateUrlForState()
    else
      stateRef = @_store.store()
      @set('stateRef', stateRef)
      @_updateUrlForState()
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
      console.error 'Invalid filter state'
      false

  _validFallbackFilter: (action, value) ->
    return false unless action? and value?

    if app.filters.validFilter(action, value)
      fallbackFilter = 
        name: action
        value: value


  # 
  # STATE RESTORATION STRATEGIES
  # 

  _restoreFromFound: (foundState) =>
    if @isValidState(foundState)
      @_setState(foundState)
      @_trackRestoreAction(@.toJSON())
    else
      @_resetState()

  _restoreFromFallback: (fallbackFilter, stateRef) ->
    if fallbackFilter
      @_setFiltersFromArray([fallbackFilter])
    else if stateRef
      return # Nothing further needed
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
    @set(@defaults, silent: true) 
    @_updateUrlForState()


  # 
  # GOOGLE ANALYTICS SINGLE-PAGE TRACKING
  # 
  _trackUrl: (url) ->
    return unless ga?
    url = url.replace(/&stateRef.*/g, "")
    ga('send', 'pageview', "/#{url}")

  _trackFilterActions: (action, facetName, facetValue) ->
    if action is 'add' and @get('filterState').length == 1
      ga('send', 'event', 'setPrimaryFilter', facetName, facetValue)

    ga('send', 'event', 'addFilter', facetName, facetValue)

  _trackStoreAction: (state) ->
    ga('send', 'event', 'saveAndLoad', 'store', state.filterState.length);

  _trackRestoreAction: (state) ->
    ga('send', 'event', 'saveAndLoad', 'restore', state.filterState.length)

