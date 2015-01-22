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
    # if no filters active then return relevant filter 
    # else search for term within currently filtered projects

  searchFilters: (term) ->
    app.facets.filters

  searchFullText: (term) ->
    @searchTitle(term)

  searchTitle: (term) ->
    app.facets.projects.removeFilter('searchTitle')
    app.facets.projects.addFilter('searchTitle', (model) ->
      re = new RegExp(term, "i")
      model.get('project_title').match(re)
    )

  clearSearch: (ev) ->
    ev.preventDefault()
    app.facets.projects.removeFilter('searchTitle')
    @$el.find('#searchField').val('')