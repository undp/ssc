class ExplorerView extends Backbone.View
  template: ->  _.template($('#explorerView').html())

  initialize: ->

  render: ->
    data =
      filter_state: 'No filters'

    compiled = @template()(data)
    @$el.html(compiled)

    @searchView = new SearchView(collection: @collection)
    @searchView.render()
    @$el.find('#search').html(@searchView.$el)

    @filterView = new FilterView(collection: @collection)
    @filterView.render()
    @$el.find('#filters').html(@filterView.$el)

    @contentView = new ContentView(collection: @collection)
    @contentView.render()
    @$el.find('#content').html(@contentView.$el)

    @

  remove: ->
    @filterView.remove() if @filterView
    @contentView.remove() if @contentView