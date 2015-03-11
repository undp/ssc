API_KEY            = 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
APP_ID             = 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
API_URL            = 'https://api.parse.com/1/classes/stateData'
INITIAL_VIEW_STATE = 'list' # TODO: @prod replace with 'map'

# 
# SERIALIZE and STORE state
# 

class StateManager
  constructor: (options) ->
    _.extend @, Backbone.Events
    throw 'No collection to manage' unless options.observedCollection?
    @observedCollection = options.observedCollection

    @listenTo @, 'filters:changed', @_storeState
    @listenTo @, 'view:changed', @_viewChanged

    @persistState = new PersistState

    @filterState = []
    @viewState = ''
    @resetState()

  retrieveStateData: (options) ->
    options.observedCollection = @observedCollection
    @persistState.retrieveStateData(options)

  resetState: ->
    @filterState = []
    @viewState = INITIAL_VIEW_STATE

  addFilterState: (facetName, facetValue, trigger) -> # Triggers filters:changed
    return false if _.findWhere(@filterState,
      name: facetName
      value: facetValue
    )

    @filterState.push
      name: facetName
      value: facetValue

    @trackFilter('add', facetName, facetValue)
    @trigger 'filters:changed' unless !trigger

  removeFilterState: (facetName, facetValue, trigger) -> # Triggers filters:changed
    return false unless foundFilter = _.findWhere(@filterState,
      name: facetName
      value: facetValue
    )

    @filterState = _.without(@filterState, foundFilter)
    @trackFilter('remove', facetName, facetValue)
    @trigger 'filters:changed' unless !trigger

  trackFilter: (action, facetName, facetValue) ->
    if action is 'add' and @filterState.length == 1
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
    @persistState.storeStateData(filterState: @filterState, viewState: @viewState)

  _viewChanged: (view) ->
    @viewState = view
    @_storeState()
