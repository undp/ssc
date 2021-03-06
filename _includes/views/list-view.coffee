class ListView extends Backbone.View
  template: -> _.template($('#listView').html())

  events:
    'click .project-list-item': '_showProject'
    'click .clear-search': '_clearSearch'

  initialize: ->
    @state = app.state

    @listenTo @collection, 'reset', @render
    
    @listenTo @state, 'search:foundProjects', @_searchedAndFoundProjects
    @listenTo @state, 'search:stopped', @_hideFoundProjects
  
  render: (options) ->
    collectionToRender = options?.collection || @collection.toJSON()
    compiled = @template()(collection: collectionToRender)
    @$el.html(compiled)
    @

  _showProject: (ev) =>
    ev.preventDefault()
    projectId = ev.currentTarget.getAttribute('data-project-id')
    @state.trigger 'content:projectShow', projectId

  _searchedAndFoundProjects: (results) =>
    @_receivedFoundProjects = true
    collectionToRender = new Backbone.Collection(results).toJSON()
    @render(collection: collectionToRender)

  _hideFoundProjects: =>
    @render() if @_receivedFoundProjects

  _clearSearch: (ev) =>
    ev.preventDefault()
    @state.trigger 'search:cancel'