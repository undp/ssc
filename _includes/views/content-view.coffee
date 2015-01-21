class ContentView extends Backbone.View
  template: ->  _.template($('#contentView').html())

  initialize: ->
    @listenTo @collection, 'reset', @render
    @render()

  render: ->
    compiled = @template()(collection: @collection)
    @$el.html(compiled)
