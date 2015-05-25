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

  attemptRestoreStateFromUrl: (options, callback) ->
    throw 'No options given' unless options?
    throw 'No callback given' unless callback?

    stateData = @_stateDataFromOptions(options)

    @_store.find(stateData.stateRef)
    .then( (result) =>
      foundState = result.results?[0]
      if foundState?
        return foundState
      else
        throw "No record matching #{stateData.stateRef} in local or remote stores"
    ).then( (result) =>
      @_restoreFromFound(result)
      callback()
    ).catch( (error) =>
      console.info(error)
      delete stateData.stateRef # If can't find, remove invalid stateRef
      @_restoreFromFound(stateData)
      callback()
    )

  # 
  # STATE RESTORATION STRATEGIES
  # 

  _restoreFromFound: (foundState) =>
    if @_isValidStateToRestore(foundState)
      @_setState(foundState)
      @_trackRestoreAction(@.toJSON())
    else
      @_resetState()

  _stateDataFromOptions: (options) ->
    stateData = {}

    if options.params?.stateRef?
      stateData.stateRef = options.params.stateRef 

    if filters = @_validFilter(options.action, options.value)
      stateData.filterState = [filters]
      stateData.fallbackFilters = filters
    else if (options.action?.match /project/) and options.value?
      stateData.projectId = options.value

    if options.params?.viewState?
      stateData.viewState = options.params.viewState 

    return stateData

  _buildFallbackState: (options) ->
    fallbackFilter = @_validFilter(options.action, options.value)
    fallbackViewState = @_validViewState(options.viewState)

    fallbackState  =
      filterState: fallbackFilter
      viewState  : fallbackViewState

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

  _isValidStateToRestore: (stateToValidate) => 
  isValidStateToStore: (stateToValidate) =>
    # TODO: Change to `validate` and use `isValid` builtin method instead.
    # Currently operates on an object with StateModel attributes, not a full StateModel instance.
    messages = []

    if stateToValidate.filterState?.length <= 0
      messages.push 'Missing filterState'
    unless stateToValidate.viewState?
      messages.push 'Missing viewState'

    if messages.length > 0
      console.error 'Invalid filter state', messages
      false
    else
      true

  _validFilter: (action, value) ->
    if app.filters.validFilter(action, value) and (action? and value?)
      fallbackFilter = 
        name: action
        value: value
    else
      false

  _validViewState: (viewState) ->
    validViews = ['list', 'stats', 'map']
    _.include(validViews, viewState)


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
    @_trackFilterActions('add', facetName, facetValue) unless options.noTrack

  removeFilter: (options) ->
    {facetName, facetValue} = options
    throw "Can't remove non-existent Facet" unless @_facetAlreadyActive(facetName, facetValue)
    @_removeFilterState(facetName, facetValue)
    @collection.removeFacet(facetName, facetValue)
    @_trackFilterActions('remove', facetName, facetValue) unless options.noTrack

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
      @addFilter(facetName: filter.name, facetValue: filter.value, noTrack: true)
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

    if stateObject?.filterState?.length > 0
      @_setFiltersFromArray(stateObject.filterState) 

  _resetState: (stateObject) =>
    console.log 'Could rescue something useful from', stateObject
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

