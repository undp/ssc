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

  _storeOnChangeEvent: (eventType) ->
    @_store.store() if (/change\:(viewState|filterState|searchTerm|projectId)/).test(eventType)

  restoreStateFromUrl: (fallbackOptions) ->
    params = app.utils.getUrlParams()
    if params.stateRef?
      console.log 'have stateRef to hunt for:', params.stateRef
      @_store.restore(params.stateRef, fallbackOptions)
    else if @_restoreStateFromFallback(fallbackOptions)
      console.log 'no stateRef to hunt for'
    else
      console.log 'start from scratch - invalid params'

  _restoreStateFromFallback: (fallbackOptions) ->
    {fallbackAction, fallbackValue} = fallbackOptions
    return false unless app.filters.validFilter(fallbackAction, fallbackValue)
    app.router.navigate ''
  # 
  # MANAGE STATE ATTRIBUTES (other than FILTERS)
  # 

  resetState: (stateObject) =>
    @clear(silent:true).set(@defaults)

  setState: (stateObject) ->
    console.log 'found', stateObject
    state = _.extend @defaults, stateObject
    @clear(silent:true).set(state, silent:true)

  setContentView: (view) =>
    @set 'viewState', view

  setProjectShowId: (projectId) =>
    @set 'projectId', projectId

  # 
  # MANAGE FILTERS
  # 

  clearFilters: ->
    @set 'filterState', []
    @collection.clearFilters()

  addFilter: (options) =>
    {facetName, facetValue} = options
    throw "Can't add duplice Facet" if @_facetAlreadyActive(facetName, facetValue)
    @_addFilterState(facetName, facetValue)
    @collection.addFilter(facetName, facetValue)

  _addFilterState: (facetName, facetValue) ->
    stateClone = _.clone(@get('filterState'))
    stateClone.push(
      name: facetName
      value: facetValue
    )
    @_trackFilterActions('add', facetName, facetValue)
    @set('filterState', stateClone)

  removeFilter: (options) ->
    {facetName, facetValue} = options
    throw "Can't remove non-existent Facet" unless @_facetAlreadyActive(facetName, facetValue)
    @_removeFilterState(facetName, facetValue)
    @collection.removeFilter(facetName, facetValue)

  _removeFilterState: (facetName, facetValue) ->
    foundFilter = @_facetAlreadyActive(facetName, facetValue)

    @set('filterState', _.without(@get('filterState'), foundFilter))
    @_trackFilterActions('remove', facetName, facetValue)

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

