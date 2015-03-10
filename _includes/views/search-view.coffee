class SearchView extends Backbone.View
  template: ->  _.template($('#searchView').html())

  initialize:  (options) ->
    @options = options || {}
    @render()

  events: 
    'click .view-mode': '_startSearch'
    'keyup .search-field-input': '_searchTerm'
    'blur .input-mode': '_cancelSearch'

  render: ->
    compiled = @template()()
    @$el.html(compiled)

  _startSearch: (ev) =>
    ev.preventDefault()
    @_activateSearch()

  _cancelSearch: (ev) ->
    ev.preventDefault()
    input = @$el.find('.search-field-input')
    input.val('')
    @_deactivateSearch()

  _activateSearch: ->
    @$el.find('.view-mode').hide()
    @$el.find('.input-mode').show()
    @$el.find('.search-field-input').focus()

  _deactivateSearch: ->
    @$el.find('.input-mode').hide()
    @$el.find('.view-mode').show()

  _searchTerm: (ev) =>
    term = ev.currentTarget.value
    return unless term.length > 1

    filterGroups = @collection.prepareFilterGroups()

    _.each filterGroups, (group) => 
      group.values = @_filterValueObjects(group.values, term)

    filterGroups # TODO: @next Take these results and replace existing FilterView collection
    @collection.trigger 'search', filterGroups

  _filterValueObjects: (valueObjects, term) ->
    _.filter(valueObjects, (object) => @_valueObjectMatchesTerm(object, term))

  _valueObjectMatchesTerm: (valueObject, term) ->
      re = new RegExp(term, 'i')
      re.test valueObject.long
      # filterResults = app.projects.filterFacets(term)
      # projectResults = app.projects.search(term)
      # ControlsView displays a SearchFacetsResultsView
      # ContentView displays a filtered list of projects matching the title/objective
      # Store search state and term in State object - can go 'back' from a ProjectShowView
