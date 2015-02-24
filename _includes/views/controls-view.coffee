class ControlsView extends Backbone.View
  template: -> _.template($('#controlsView').html())

  initialize:  (options) ->
    @options = options || {}
    @render()

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)

    @searchView = new SearchView(el: @$el.find('#searchView'), collection: @collection)
    @filterView = new FilterView(el: @$el.find('#filterView'), collection: @collection)

    @
