class HeadlinesView extends Backbone.View
  template: ->  _.template($('#headlinesView').html())

  initialize: ->
    @listenTo @collection, 'filters:add', @render
    @listenTo @collection, 'filters:remove', @render
    @listenTo @collection, 'filters:reset', @render

    @render()

  render: ->
    compiled = @template()(
      collection: @collection
      stats: @calculateStats()
    )
    @$el.html(compiled)
    @

  calculateStats: ->
    activeCountriesCount: 
      _.select(_.select(app.projects.facets(), (i) -> 
        i.data.name =='host_location'
      )[0].values, (i) -> 
        i.value != ""
      ).length
