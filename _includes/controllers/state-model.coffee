API_KEY            = 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
APP_ID             = 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
API_URL            = 'https://api.parse.com/1/classes/stateData'
INITIAL_VIEW_STATE = 'map' # TODO: @prod Ensure this is 'map'

# 
# SERIALIZE and STORE state
# 

class StateModel extends Backbone.Model
  initialize: ->
    @listenTo @, 'state:reset', @_resetState
    @_stateStore = new StateStore # Mixin/Utility class
    @_resetState()

  writeStateToUrl: ->

  readStateFromUrl: ->

    params = app.utils.getUrlParams()
    if params.stateRef? # Try to find State from stores (local and remote)
      options = 
        facetName: facetName
        facetValue: facetValue
        stateRef: params.stateRef
        viewState: params.viewState

      @retrieveStateData(options) 

    else if facetName and facetValue # Use given primary facet name and value
      @clearFilters()
      @addFilter(name: facetName, value: facetValue)

    else # Start from scratch
      @clearFilters()

  _resetState: ->
    @set 'filterState', []
    @set 'viewState', INITIAL_VIEW_STATE

  clearFilters: ->
    @collection.clearFilters()
    @set 'filterState', []

  addFilter: (options) =>
    {facetName, facetValue} = options

    # return false unless @collection.facetAvailable(facetName, facetValue)
    throw "Can't add duplice Facet" if @_facetAlreadyActive(facetName, facetValue)

    @collection.addFilter(facetName, facetValue)
    @_addFilterState(facetName, facetValue)

  _addFilterState: (facetName, facetValue) -> # Triggers filters:changed
    filterState = @get 'filterState'
    @set 'filterState', filterState.push
      name: facetName
      value: facetValue

    @_trackFilterActions('add', facetName, facetValue)

  removeFilter: (options) ->
    {facetName, facetValue} = options

    @collection.removeFilter(facetName, facetValue)
    @_removeFilterState(facetName, facetValue)

  _removeFilterState: (facetName, facetValue) -> # Triggers filters:changed
    throw "Can't remove non-existent Facet" unless foundFilter = @_facetAlreadyActive(facetName, facetValue)

    @set 'filterState', _.without(@get('filterState'), foundFilter)
    @_trackFilterActions('remove', facetName, facetValue)
    # @trigger 'filters:changed' unless !trigger

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

  _storeState: =>
    @_stateStore.store()

