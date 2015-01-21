class FilterView extends Backbone.View
  template: ->  _.template($('#filterView').html())

  events: 
    'keyup #search_box': 'search'
    'click #clearSearch': 'clearSearch'

  initialize: ->
    @listenTo @collection, 'reset', @render

  render: ->
    compiled = @template()(filterState: 'not stated')
    @$el.html(compiled)

  search: (ev) ->
    term = ev.currentTarget.value
    results = @collection.findBySearch(term)
    console.log "#{results.length || 0} matching projects"

  clearSearch: (ev) ->
    ev.preventDefault()
    @$el.find('#searchField').val('')