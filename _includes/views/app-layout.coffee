class AppLayout extends Backbone.View

  events: 
    'click a.project': 'clicked'
  
  clicked: (ev) ->
    ev.preventDefault()
    router.navigate ev.currentTarget.hash, trigger: true

  initialize: ->
    @template = _.template($('#appTemplate').html())
    @itemTemplate = _.template($('#projectListItem').html())
    @render()

  render: ->
    compiled = @template()
    @$el.html(compiled)
    $table = @$el.find('table tbody')
    @collection.each (project) =>
      $table.append @itemTemplate(project.toJSON())
    @