class app.views.App extends Backbone.View
  el: '#app'
  
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

