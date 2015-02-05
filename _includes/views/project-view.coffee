class ProjectView extends Backbone.View
  template: -> _.template($('#projectView').html())

  className: 'row'

  events:
    'click .triggerIframeResize': 'triggerIframeResize'

  render: ->
    @presentedModel = new PresentProject(@model)
    compiled = @template()(project: @presentedModel.render())
    @$el.html(compiled)
    @

  triggerIframeResize: ->
    if doc = document.getElementById('project_iframe')
      newheight = doc.contentWindow.document.body.scrollHeight
      doc.height= (newheight) + "px"
      $('#contentTruncated').hide()
