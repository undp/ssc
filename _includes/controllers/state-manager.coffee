API_KEY            = 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
APP_ID             = 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
API_URL            = 'https://api.parse.com/1/classes/stateData'
INITIAL_VIEW_STATE = 'list'

# 
# SERIALIZE and STORE state
# 

class StateManager
  constructor: (options) ->
    _.extend @, Backbone.Events
    throw 'No collection to manage' unless options.observedCollection?
    @observedCollection = options.observedCollection
    @listenTo @observedCollection, 'filters:add', @_storeState
    @listenTo @observedCollection, 'filters:remove', @_storeState
    # @listenTo @observedCollection, 'filters:change', @_storeState # TODO: Replace 'add' & 'remove' with single 'change' filters event

    @listenTo @, 'view:changed', @_viewChanged

    @persistState = new PersistState

    @filterState = []
    @viewState = ''
    @resetState()

  retrieveStateData: (options) ->
    options.observedCollection = @observedCollection
    @persistState.retrieveStateData(options)

  _storeState: =>
    @persistState.storeStateData(filterState: @filterState, viewState: @viewState)
    console.log 'stored state using PersistState#storeStateData'

  resetState: ->
    @filterState = []
    @viewState = INITIAL_VIEW_STATE

  _viewChanged: (view) ->
    @viewState = view
    @_storeState()


  addFilterState: (facetName, facetValue, trigger) -> # Triggers filters:add
    return false if _.findWhere(@filterState,
      name: facetName
      value: facetValue
    )

    @filterState.push
      name: facetName
      value: facetValue

    @trigger 'filters:add' unless !trigger

  removeFilterState: (facetName, facetValue, trigger) -> # Triggers filters:remove
    return false unless foundFilter = _.findWhere(@filterState,
      name: facetName
      value: facetValue
    )

    @filterState = _.without(@filterState, foundFilter)

    @trigger 'filters:remove' unless !trigger
