class ControlsView extends Backbone.View
  template: -> _.template($('#controlsView').html())

  initialize: ->
    @render()

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)

    @_searchView = new SearchView(parentView: @, el: @$el.find('.search-container'), collection: @collection)
    @_filterView = new FilterView(parentView: @, el: @$el.find('.filters-container'), collection: @collection)
    @

  remove: ->
    @_searchView.remove() if @_searchView?
    @_filterView.remove() @_filterView?
    Backbone.View.prototype.remove.apply(this, arguments)