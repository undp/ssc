class ProjectView extends Backbone.View
  template: -> _.template($('#projectView').html())

  className: 'row'

  events:
    'click .filter': '_filter'
    'click .triggerIframeResize': '_triggerIframeResize'
    'click .backToResults': '_backToResults'

  initialize: ->
    @state = app.state
    _.template.partial.declare('filterItem', $('#partial-filterItem').html())

  render: ->
    @presentedModel = new PresentProject(@model)
    compiled = @template()(project: @presentedModel.render())
    @$el.html(compiled)
    window.scrollTo(0,0)
    @

  _backToResults: (ev) =>
    ev.preventDefault()
    @state.trigger 'content:projectIndex'

  _filter: (ev) ->
    ev.preventDefault()
    data = ev.target.dataset
    console.log "Show all: filtering type #{data.filterName} for value #{data.filterValue}"

  _triggerIframeResize: (ev) ->
    ev.preventDefault()
    if doc = document.getElementById('project_iframe')
      newheight = doc.contentWindow.document.body.scrollHeight
      doc.height= (newheight) + "px"
      $('#contentTruncated').hide()
