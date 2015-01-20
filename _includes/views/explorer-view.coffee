class ExplorerView extends Backbone.View
  template: ->  _.template($('#explorerView').html())

  events:
    'keyup #search_box': 'search'

  initialize: ->
    @listenTo @collection, 'change', @render
    # @filterView = new FilterView
    @render()

  search: (ev) ->
    term = ev.currentTarget.value
    results = @collection.findBySearch(term)
    console.log "#{results.length || 0} matching projects"

  render: ->
    data =
      filter_state: 'No filters'

    compiled = @template()(data)
    @$el.html(compiled)
    @contentView = new ContentView(collection: @collection)
    @$el.find('#content').html(@contentView.render())
    @$el
