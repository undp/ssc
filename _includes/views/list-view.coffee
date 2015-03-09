class ListView extends Backbone.View
  template: -> _.template($('#listView').html())

  events: 
    'click .results-list-item': '_showProject'

  initialize: (options) ->
    throw "Missing parentView" unless options.parentView?
    {@parentView} = options

    @listenTo @collection, 'reset', @render
    
  render: ->
    @$el = @parentView.$el.find('.tab-content[data-w-tab="list"]')
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    @

  _showProject: (ev) ->
    ev.preventDefault()
    projectId = ev.currentTarget.dataset
    console.log 'show project', projectId