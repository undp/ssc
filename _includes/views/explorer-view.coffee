class ExplorerView extends Backbone.View
  initialize: ->
    @template = _.template($('#explorerView').html())
    @render()

  render: ->
    compiled = @template()
    @$el.html(compiled)
