class ProjectView extends Backbone.View
  el: '#projectShow'

  template: -> _.template($('#projectView').html())

  events:
    'click .filter': '_addFilter'
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

  _addFilter: (ev) ->
    ev.preventDefault()
    elem = ev.currentTarget
    @state.addFilter(
      facetName: elem.getAttribute('data-filter-name')
      facetValue: elem.getAttribute('data-filter-value')
    )
