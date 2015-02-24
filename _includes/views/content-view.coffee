class ContentView extends Backbone.View
  template: -> _.template($('#contentView').html())

  events:
    'click .tab-menu-link': 'selectTabLink'

  initialize: ->
    @listenTo @collection, 'reset', @render
    @render()

  render: ->
    # TODO: console.log 'reset collection -> render contentView'
    compiled = @template()(collection: @collection.toJSON())
    @$el.html(compiled)
    # @$el.find("#map").hide()
    # _.defer @vectorMap
    @

  selectTabLink: (ev) =>
    tabAttr = 'data-w-tab'
    linkActive = 'w--current'
    tabActive = 'w--tab-active'

    tab = ev.currentTarget.getAttribute(tabAttr)

    @$el.find('.tab-menu-link').removeClass(linkActive)
    @$el.find(".tab-menu-link[data-w-tab='#{tab}']").addClass(linkActive)

    @$el.find('.w-tab-pane').removeClass(tabActive)
    @$el.find(".w-tab-pane[data-w-tab='#{tab}']").addClass(tabActive)

  vectorMap: =>
    # TODO: console.log 'render map called'
    values = _.object(
      _.map(countries, (i) ->
        [[i.iso2],[Math.floor((Math.random() * 100) + 1)]]
      )
    )
    $('#map').vectorMap(
      map: 'world_mill_en'
      series:
        regions: [
          values: values
          scale: ['#C8EEFF', '#0071A4']
          normalizeFunction: 'polynomial'
        ]
      regionsSelectable: true
      regionsSelectableOne: true
      # focusOn: region: 'gb'
      onRegionSelected: (ev, code) =>
        console.log(code)
        @zoomToRegion(code)
    )
    @mapObject = $('#map').vectorMap('get', 'mapObject')

  zoomToRegion: (code) =>
    @mapObject.setFocus(region: code, animate: true)

  # freezeContentHeight: =>
  #   contentDiv = $("#content")
  #   fromTop = contentDiv.offset().top
  #   contentDiv.height(@$el.find('#map').height() + 380 + 'px')
  #   window.scroll(0, fromTop)
  #   @resizeMapFrame()

  # resizeThrottler: =>
  #   _.throttle =>
  #     @resized = false
  #     @resizeMapFrame()
  #   , 500

  # resizeMapFrame: =>
  #   mapDiv = @$el.find('#map')
  #   mapDiv.height($(window).height() - 100)

  #   if @visible == 'map' && !@resized
  #     @resized = true
  #     _.defer -> google.maps.event.trigger(map, 'resize')
