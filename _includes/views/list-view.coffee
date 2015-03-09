class ListView extends Backbone.View
  template: -> _.template($('#listView').html())

  events: 
    'click .results-list-item': '_showProject'

  initialize: ->
    @listenTo @collection, 'reset', @render
  
  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    @

  _showProject: (ev) ->
    ev.preventDefault()
    projectId = ev.currentTarget.dataset
    console.log 'show project', projectId