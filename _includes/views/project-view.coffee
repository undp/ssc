class ProjectView extends Backbone.View
  template: -> _.template($('#projectView').html())

  initialize: ->

  render: ->
    compiled = @template()(project: @model.toJSON())
    @$el.html(compiled)
    @