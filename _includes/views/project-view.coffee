class ProjectView extends Backbone.View
  template: -> _.template($('#projectView').html())

  initialize: ->

  render: ->
    @presentedModel = new PresentProject(@model)
    compiled = @template()(project: @presentedModel.render())
    @$el.html(compiled)
    @