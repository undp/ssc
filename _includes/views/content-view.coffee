class ContentView extends Backbone.View
  template: -> _.template($('#contentView').html())

  initialize: ->
    @listenTo @collection, 'reset', @render

  render: ->
    console.log 'and this?'
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    @