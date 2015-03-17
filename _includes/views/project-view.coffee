class ProjectView extends Backbone.View
  el: '#projectShow'

  template: -> _.template($('#projectView').html())

  events:
    'click .filter': '_filter'
    'click .back-link': '_backToResults'

  initialize: ->
    @state = app.state
    _.template.partial.declare('filterItem', $('#partial-filterItem').html())

  render: ->
    compiled = @template()(project: @model.toJSON())
    @$el.html(compiled)
    @

  remove: ->
    @$el.empty()
    @undelegateEvents()

  _backToResults: (ev) =>
    ev.preventDefault()
    @state.trigger 'content:projectIndex'

  _filter: (ev) ->
    ev.preventDefault()
    data = ev.target.dataset
    @state.addFilter(facetName: data.filterName, facetValue: data.filterValue)
