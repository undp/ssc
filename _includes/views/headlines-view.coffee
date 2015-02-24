class HeadlinesView extends Backbone.View
  template: ->  _.template($('#headlinesView').html())

  initialize: ->
    @listenTo @collection, 'filters:add', @render
    @listenTo @collection, 'filters:remove', @render
    @listenTo @collection, 'filters:reset', @render

    @render()

  render: ->
    compiled = @template()(
      collection: @collection
    )
    @$el.html(compiled)
    @

