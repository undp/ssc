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
    # if term.length > 1
      # filterResults = app.projects.filterFacets(term)
      # projectResults = app.projects.search(term)
      # ControlsView displays a SearchFacetsResultsView
      # ContentView displays a filtered list of projects matching the title/objective
      # Store search state and term in State object - can go 'back' from a ProjectShowView
