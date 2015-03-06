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
    activeCountriesCount: 
      @collection.prepareFilterGroupForType('host_location').length

  _resetFilters: =>
    @collection.clearFilters()