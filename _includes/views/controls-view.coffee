class ControlsView extends Backbone.View
  template: -> _.template($('#controlsView').html())

  initialize:  (options) ->
    @options = options || {}

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)

    @searchView = new SearchView(el: @$el.find('#search'), collection: @collection)
    @searchView.render()

    @filterView = new FilterView(el: @$el.find('#filter'), collection: @collection)
    @filterView.render()

    @
