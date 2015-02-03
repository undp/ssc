class ContentView extends Backbone.View
  template: -> _.template($('#contentView').html())
  
  events:
    'click .toggle_list_map': 'toggleListMap'

  initialize: ->
    @listenTo @collection, 'reset', @render
    @visible = 'list' unless @visible # TODO: Swap with viewModel

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    @$el.find("#map").hide()
    _.defer @initializeMap
    @

  initializeMap: =>
    @mapController = new MapController(@$el.find('#map')[0])
    @map = @mapController.activateMap()

  toggleListMap: (ev) ->
    ev.preventDefault()
    @$el.find('#list').toggle()
    @$el.find('#map').toggle()
    google.maps.event.trigger(map, 'resize')

