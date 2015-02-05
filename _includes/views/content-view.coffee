class ContentView extends Backbone.View
  template: -> _.template($('#contentView').html())
  
  events:
    'click .toggle_list_map': 'toggleListMap'
    'click .scrollControls': 'scrollControls'

  initialize: ->
    @listenTo @collection, 'reset', @render
    @visible = 'list' unless @visible # TODO: Use a viewModel

  render: ->
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    @$el.find("#map").hide()
    _.defer @initializeMap
    @

  scrollControls: ->
    $('html, body').animate({scrollTop: $("#controls").offset().top}, 500)

  initializeMap: =>
    @mapController = new MapController(@$el.find('#map')[0])
    @map = @mapController.activateMap()

  toggleListMap: (ev) ->
    ev.preventDefault()
    @$el.find('#list').toggle()
    @$el.find('#map').toggle()
    google.maps.event.trigger(map, 'resize') if @visible == 'map'

