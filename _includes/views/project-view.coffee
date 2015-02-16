class ProjectView extends Backbone.View
  template: -> _.template($('#projectView').html())

  className: 'row'

  events:
    'click .filter': 'filter'
    'click .triggerIframeResize': 'triggerIframeResize'
    'click .backToResults': 'backToResults'

  initialize: ->
    _.template.partial.declare('filterItem', $('#partial-filterItem').html())

  render: ->
    @presentedModel = new PresentProject(@model)
    compiled = @template()(project: @presentedModel.render())
    @$el.html(compiled)
    window.scrollTo(0,0)
    @

  backToResults: (ev) ->
    ev.preventDefault()
    app.router.back()

  filter: (ev) ->
    ev.preventDefault()
    data = ev.target.dataset
    console.log "Show all: filtering type #{data.filterName} for value #{data.filterValue}"

  triggerIframeResize: ->
    if doc = document.getElementById('project_iframe')
      newheight = doc.contentWindow.document.body.scrollHeight
      doc.height= (newheight) + "px"
      $('#contentTruncated').hide()
