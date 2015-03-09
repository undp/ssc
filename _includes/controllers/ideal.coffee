class Projects extends Backbone.Collection
  # Does very little - acted on by Facets
  initialize: ->
    _.extend @, ProjectsFacets
    @facetr = Facetr(@collection)

class Filters extends Backbone.Collection
  # Holds list of Filters for rendering, not storing state
  initialize: () ->
    @addCountries()

class StateManager
  initialize: ->
    @view = 'map'
    @filterState = []
    {@collection} = options

  addFilter: (facetName, facetValue) ->
  removeFilter: (facetName, facetValue) ->
  clearFilters: ->

class Router
  routes: {}
  explorerView: () ->
    # Parse URL and recreate state
  updateUrlForState: (state) ->


# TODO: Remove notes and whole file!
===

# ContentView (+children)
#   - listenTo Projects Collection
#   - render changes

ControlsView (+children)
  - listenTo Projects Collection
  - render filters based from Projects
  - use FiltersCollection to translate terms


1. user adds/removes/clear a filter
  - add/remove/clear filter to collection
  - re-render all affected pieces
  - update filterState
  - persist state

  @state.addFilter('host_location', 'afg')
  @state.setView('map')



2. user changes view
  - change view displayed
  - update viewState
  - persist state

3.user arrives via URL
  - parse URL
  - retrieve persistedState if possible
  - otherwise navigate to best guess
  - 