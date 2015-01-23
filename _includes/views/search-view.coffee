class SearchView extends Backbone.View
  template: ->  _.template($('#searchView').html())

  events: 
    'keyup #searchField': 'search'
    'click #clearSearch': 'clearSearch'

  render: ->
    compiled = @template()()
    @$el.html(compiled)

  search: (ev) ->
    term = ev.currentTarget.value
    app.vent.trigger 'search', term
    # results = app.filters.search(term)
    # console.log results.map (i) -> 
    #   "#{i.get('type')}: #{i.id}"

    # if no filters active then return relevant filter 
    # else search for term within currently filtered projects


  searchTitle: (term) ->
    app.projects.facetr.removeFilter('searchTitle')
    app.projects.facetr.addFilter('searchTitle', (model) ->
      re = new RegExp(term, "i")
      model.get('project_title').match(re)
    )

  clearSearch: (ev) ->
    ev.preventDefault()
    @$el.find('#searchField').val('')
    app.vent.trigger 'search', ''