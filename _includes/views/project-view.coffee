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
    app.utils.resizeIframe('project_iframe')