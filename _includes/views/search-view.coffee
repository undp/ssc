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
    app.facets.projects.removeFilter('searchTitle')
    app.facets.projects.addFilter('searchTitle', (model) ->
      re = new RegExp(term, "i")
      model.get('project_title').match(re)
    )

  clearSearch: (ev) ->
    ev.preventDefault()
    app.facets.projects.removeFilter('searchTitle')
    @$el.find('#searchField').val('')