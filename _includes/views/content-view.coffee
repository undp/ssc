class ContentView extends Backbone.View
  template: -> _.template($('#contentView').html())
  
  events:
    'click .changeView': 'changeView'
    'click .scrollControls': 'scrollControls'

  initialize: ->
    @listenTo @collection, 'reset', @render
    @visible = 'list' unless @visible # TODO: Use a viewModel
    window.addEventListener("resize", @resizeMapFrame, false)

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

  changeView: (ev) =>
    ev.preventDefault()
    @visible = 'map'
    @freezeContentHeight()
    @$el.find('#list').toggle()
    @$el.find('#map').toggle()

  freezeContentHeight: =>
    contentDiv = $("#content")
    fromTop = contentDiv.offset().top
    contentDiv.height(@$el.find('#map').height() + 380 + 'px')
    window.scroll(0, fromTop)
    @resizeMapFrame()

  resizeThrottler: =>
    _.throttle =>
      @resized = false
      @resizeMapFrame()
    , 500
    
  resizeMapFrame: =>
    mapDiv = @$el.find('#map')
    mapDiv.height($(window).height() - 100)
    
    if @visible == 'map' && !@resized
      @resized = true
      _.defer -> google.maps.event.trigger(map, 'resize') 