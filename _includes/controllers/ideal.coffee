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



@collection.addFilter()
@collection.removeFilter()
@collection.clearFilters()

@state.addFilter() ->
  @collection.addFilter()
  @storeFilterState()