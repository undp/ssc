class ListView extends Backbone.View
  template: -> _.template($('#listView').html())

  initialize: ->
    @listenTo @collection, 'reset', @render
  
  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    @
