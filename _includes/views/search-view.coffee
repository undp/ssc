class SearchView extends Backbone.View
  template: ->  _.template($('#searchView').html())

  initialize: ->
    @render()

  events: 
    'click .view-mode': '_prepareForSearch'
    'click .input-mode > .search-action-icon': '_cancelSearch'
    'keyup .search-field-input': '_searchForTerm'

  render: ->
    compiled = @template()()
    @$el.html(compiled)

  _prepareForSearch: (ev) =>
    ev.preventDefault()
    @_activateSearch()

  _cancelSearch: (ev) ->
    ev.preventDefault()
    @_resetSearchField()
    @_deactivateSearch()
    @collection.trigger('search:stopped')

  _resetSearchField: =>
    input = @$el.find('.search-field-input')
    input.val('')

  _activateSearch: ->
    @$el.find('.view-mode').hide()
    @$el.find('.input-mode').show()
    @$el.find('.search-field-input').focus()

  _deactivateSearch: ->
    @$el.find('.input-mode').hide()
    @$el.find('.view-mode').show()

  _searchForTerm: (ev) =>
    term = ev.currentTarget.value
    return unless term.length > 1
    @_searchFilterGroups(term)
    @_searchProjects(term)

  _searchProjects: (term) =>
    projectsFound = @collection.search(term)
    if projectsFound?.length > 0
      # NOTE: The event below is called on @collection
      @collection.trigger('search:foundProjects', projectsFound) 

  _searchFilterGroups: (term) =>
    filterGroups = @collection.prepareFilterGroups()

    _.each filterGroups, (group) => 
      group.values = @_filterValueObjects(group.values, term)
    # NOTE: The event below is called on @collection
    @collection.trigger('search:foundFilters', filterGroups)

  _filterValueObjects: (valueObjects, term) ->
    _.filter(valueObjects, (object) => @_valueObjectMatchesTerm(object, term))

  _valueObjectMatchesTerm: (valueObject, term) ->
      re = new RegExp(term, 'i')
      re.test valueObject.long
      # TODO: @next Add the Projects search action
      # filterResults = app.projects.filterFacets(term)
      # projectResults = app.projects.search(term)
      
      # ControlsView displays a SearchFacetsResultsView
      # ContentView displays a filtered list of projects matching the title/objective
      # Store search state and term in State object - can go 'back' from a ProjectShowView
