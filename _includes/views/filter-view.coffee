class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  events:
    'click .filter.result': 'clicked'

  clicked: (ev) ->
    console.log 'clicked'

  initialize: ->
    @listenTo @collection, 'reset', @render
    @listenTo app.vent, 'search', @search
    @resetFilterGroups()

  resetFilterGroups: ->
    @filterGroups = _.groupBy(app.filters.toArray(), (i) ->
      i.get('forFilter')
    )

  search: (term) ->
    if term
      @filterGroups = _.groupBy(app.filters.search(term), (i) ->
        i.get('forFilter')
      )
    else
      @resetFilterGroups()
    @render()

  searchTitle: (term) ->
    app.projects.facetr.removeFilter('searchTitle')
    app.projects.facetr.addFilter('searchTitle', (model) ->
      re = new RegExp(term, "i")
      model.get('project_title').match(re)
    )


  render: ->
    compiled = @template()(
      collection: @collection
      filterGroups: @filterGroups
    )
    @$el.html(compiled)
