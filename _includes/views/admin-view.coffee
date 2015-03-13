class AdminView extends Backbone.View
  template: ->  _.template($('#adminView').html())

  initialize:  () ->
    @render()

  render: (options) =>
    compiled = @template()(
      existingProjects: @collection.toJSON()
      
    )
    @$el.html(compiled)  