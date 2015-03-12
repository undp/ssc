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
    modeState   : 'index'
    projectId   : null

  initialize: ->
    @listenTo @, 'state:reset', @_resetState
    @listenTo @, 'all', @_allChanges
    @_stateStore = new StateStore # Mixin/Utility class

  _allChanges: (eventType,b,c) ->
    console.log 'Type is:', eventType.match(/change\:?.*/)
    # console.log eventType,b,c

  writeStateToUrl: ->

  readStateFromUrl: ->
    console.log 'DEV: Reading URL disabled'
    # params = app.utils.getUrlParams()
    # if params.stateRef? # Try to find State from stores (local and remote)
    #   options = 
    #     facetName: facetName
    #     facetValue: facetValue
    #     stateRef: params.stateRef
    #     viewState: params.viewState

    #   @retrieveStateData(options) 

    # else if facetName and facetValue # Use given primary facet name and value
    #   @clearFilters()
    #   @addFilter(name: facetName, value: facetValue)

    # else # Start from scratch
    #   @clearFilters()

  _storeState: (ev) =>
    console.log 'Check if anything changed before storing - possibly by checking event type', ev
    @_stateStore.store()

  _resetState: =>
    @clear().set(@defaults)

  clearFilters: ->
    @set 'filterState', []
    @collection.clearFilters()

  setView: (view) =>
    @set 'viewState', view

  addFilter: (options) =>
    {facetName, facetValue} = options
    throw "Can't add duplice Facet" if @_facetAlreadyActive(facetName, facetValue)
    @_addFilterState(facetName, facetValue)
    @collection.addFilter(facetName, facetValue)

  _addFilterState: (facetName, facetValue) -> # Triggers filters:changed
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

  _removeFilterState: (facetName, facetValue) -> # Triggers filters:changed
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

