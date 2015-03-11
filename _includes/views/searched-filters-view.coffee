class SearchedFiltersView extends Backbone.View
  template: ->  _.template($('#searchedFiltersView').html())

  initialize:  (options) ->
    @options = options || {}
    @listenTo @collection, 'reset', @render
    @listenTo @collection, 'search', @_searchForTerm # TODO: Don't use Projects for these events
    @render()

  render: =>
    compiled = @template()(
      filterGroups: @_prepareFilterGroups()
    )
    @$el.html(compiled)

  _prepareFilterGroups: =>
    @collection.prepareFilterGroups()

  _searchForTerm: (found) ->
    console.warn 'This is a nasty event listener', found