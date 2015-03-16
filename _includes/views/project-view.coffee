class ProjectView extends Backbone.View
  el: '#projectShow'

  template: -> _.template($('#projectView').html())

  events:
    'click .filter': '_filter'
    'click .triggerIframeResize': '_triggerIframeResize'
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

  _triggerIframeResize: (ev) ->
    ev.preventDefault()
    if doc = document.getElementById('project_iframe')
      newheight = doc.contentWindow.document.body.scrollHeight
      doc.height= (newheight) + "px"
      $('#contentTruncated').hide()
