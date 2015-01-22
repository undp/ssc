class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

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

  render: ->
    compiled = @template()(
      collection: @collection
      filterGroups: @filterGroups
    )
    @$el.html(compiled)
