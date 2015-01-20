class ContentView extends Backbone.View
  template: ->  _.template($('#contentView').html())

  initialize: ->
    @render()

  render: ->
    data = 
      collection: @collection
    compiled = @template()(data)
    @$el.html(compiled)
