class HeadlinesView extends Backbone.View
  template: ->  _.template($('#headlinesView').html())

  events: 
    'click .reset': '_resetFilters'

  initialize: ->
    @listenTo @collection, 'reset', @render
    @listenTo @collection, 'filters:add', @render
    @listenTo @collection, 'filters:remove', @render
    @listenTo @collection, 'filters:reset', @render

    @render()

  render: ->
    compiled = @template()(
      collection: @collection
      stats: @_calculateStats()
    )
    @$el.html(compiled)
    @

  _calculateStats: ->
    filterState = app.state.filterState

    activeCountriesCount: 
      @collection.prepareFilterGroupForType('host_location').length
    primaryFilterTitle:
      if filterState[0]?
        app.filters.nameFromShort(filterState[0].value)
      else
        'All projects'
    hasSecondaryFilters:
      filterState.length > 1
    secondaryFilterCount:
      filterState.length - 1

  _resetFilters: =>
    @collection.clearFilters()