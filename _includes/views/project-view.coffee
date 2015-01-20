class ProjectView extends Backbone.View

  initialize: ->
    @template = _.template($('#projectView').html())
    @render()

  render: ->
    compiled = @template()
    @$el.html(compiled)
    @