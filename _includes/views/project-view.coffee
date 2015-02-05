class ProjectView extends Backbone.View
  template: -> _.template($('#projectView').html())

  className: 'row'

  initialize: ->
    $(window).on 'resize', @triggerIframeResize

  render: ->
    @presentedModel = new PresentProject(@model)
    compiled = @template()(project: @presentedModel.render())
    @$el.html(compiled)
    @triggerIframeResize()
    @

  triggerIframeResize: ->
    _.delay ->
      if doc = document.getElementById('project_iframe')
        newheight = doc.contentWindow.document.body.scrollHeight
        doc.height= (newheight) + "px"
        $('#contentTruncated').hide()
    , 800
