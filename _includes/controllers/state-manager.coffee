API_KEY            = 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
APP_ID             = 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
API_URL            = 'https://api.parse.com/1/classes/stateData'
INITIAL_VIEW_STATE = 'list'

# 
# SERIALIZE and STORE state
# 

class StateManager
  constructor: (options) ->
    console.log 'created'
    _.extend @, Backbone.Events
    throw 'No collection to manage' unless options.observedCollection?
    @observedCollection = options.observedCollection
    @listenTo @observedCollection, 'filters:add', @_storeState
    @listenTo @observedCollection, 'filters:remove', @_storeState    
    # @listenTo @observedCollection, 'filters:change', @_storeState # TODO: Replace 'add' & 'remove' with single 'change' filters event

    @persistState = new PersistState
    @filterState = [] # TODO: Probably move from this Collection to a ViewModel
    @viewState = ''
    @_resetState()

  _storeState: =>
    @persistState.storeStateData(filterState: @filterState, viewState: @viewState)
    console.log 'stored state using PersistState#storeStateData'

  _resetState: ->
    @filterState = [] # TODO: Probably move from this Collection to a ViewModel
    @viewState = INITIAL_VIEW_STATE # TODO: Definitely move from this Collection to a ViewModel
