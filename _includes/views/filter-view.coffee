class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  events:
    'click .activeFilter': 'removeFilter'


  initialize:  (options) ->
    @options = options || {}
    @viewModel = @options.viewModel

    @listenTo @collection, 'reset', @render
    @listenTo @collection, 'filters:reset', @render
    @listenTo @viewModel, 'change', @heard
    @listenTo app.vent, 'search', @search # TODO: Wrong place to listen for this

    @resetFilterGroups()

  heard: (ev) ->
    console.log('filter event heard')

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

  removeFilter: (ev) =>
    ev.preventDefault()
    data = ev.currentTarget.dataset
    @collection.removeFilter(data.filterName, data.filterValue)
    console.log "removed filter for #{data.filterName}:#{data.filterValue}"

  # searchTitle: (term) ->
  #   app.projects.facetr.removeFilter('searchTitle')
  #   app.projects.facetr.addFilter('searchTitle', (model) ->
  #     re = new RegExp(term, "i")
  #     model.get('project_title').match(re)
  #   )

  render: ->
    compiled = @template()(
      activeFilters: @collection.filterState
      collection: @collection
      filterGroups: @filterGroups
    )
    @$el.html(compiled)
