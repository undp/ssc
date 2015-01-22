class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  initialize: ->
    @listenTo @collection, 'reset', @render

  render: ->
    facets = app.projects.facetr.toJSON()
    filterFacets = _.groupBy(app.filters.search('af'), (i) ->
      i.get('type')
    )
    compiled = @template()(
      collection: @collection
      filterFacets: filterFacets
    )
    @$el.html(compiled)
