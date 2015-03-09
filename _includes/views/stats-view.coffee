class StatsView extends Backbone.View
  template: -> _.template($('#statsView').html())

  initialize: ->
    @listenTo @collection, 'reset', @render

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    @