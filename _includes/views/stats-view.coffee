class StatsView extends Backbone.View
  template: -> _.template($('#statsView').html())

  initialize: (options) ->
    throw "Missing parentView" unless options.parentView?
    {@parentView} = options
    
    @listenTo @collection, 'reset', @render

  render: ->
    @$el = @parentView.$el.find('.tab-content[data-w-tab="stats"]')
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    @