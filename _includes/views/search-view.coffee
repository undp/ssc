class SearchView extends Backbone.View
  template: ->  _.template($('#searchView').html())

  initialize:  (options) ->
    @options = options || {}
    @render()

  events: 
    'click .view-mode': 'startSearch'
    'keyup .search-field-input': 'searchTerm'
    'blur .input-mode': 'cancelSearch'

  render: ->
    compiled = @template()()
    @$el.html(compiled)

  startSearch: (ev) =>
    ev.preventDefault()
    @activateSearch()

  cancelSearch: (ev) ->
    ev.preventDefault()
    input = @$el.find('.search-field-input')
    input.val('')
    @deactivateSearch()

  activateSearch: ->
    @$el.find('.view-mode').hide()
    @$el.find('.input-mode').show()
    @$el.find('.search-field-input').focus()

  deactivateSearch: ->
    @$el.find('.input-mode').hide()
    @$el.find('.view-mode').show()

  searchTerm: (ev) =>
    term = ev.currentTarget.value
    if term.length > 1
      results = app.filters.search(term)
      console.log results.map (i) -> 
        "#{i.get('type')}: #{i.id}"


  #   # if no filters active then search all filter 
  #   # if @viewModel.activeFilters.length == 0
  #   # else search for term within currently filtered projects


  # searchTitle: (term) ->
  #   app.projects.facetr.removeFilter('searchTitle')
  #   app.projects.facetr.addFilter('searchTitle', (model) ->
  #     re = new RegExp(term, "i")
  #     model.get('project_title').match(re)
  #   )
