class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  initialize: ->
    @listenTo @collection, 'reset', @render

  render: ->
    facets = app.projects.facetr.toJSON()
    regionFacet = facets.filter((i) -> i.data.name == 'region')[0]
    compiled = @template()(
      collection: @collection
      regionFacet: regionFacet
      filterState: 'not stated'
    )
    @$el.html(compiled)
