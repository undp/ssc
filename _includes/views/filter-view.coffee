class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())


  events:
    'click .filter.result': 'clicked'

  clicked: (ev) ->
    console.log 'clicked'

  initialize:  (options) ->
    @options = options || {}
    @viewModel = @options.viewModel

    @listenTo @collection, 'reset', @render
    @listenTo @viewModel, 'change', @heard
    @listenTo app.vent, 'search', @search # TODO: Wrong place to listen for this

    @resetFilterGroups()

  heard: ->
    console.log('filter heard')

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
