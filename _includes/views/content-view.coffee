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
    _.defer @vectorMap
    @selectTab('map')
    @

  selectTabLink: (ev) =>
    tab = ev.currentTarget.getAttribute('data-w-tab')
    @selectTab(tab)

  selectTab: (tab) ->
    linkActive = 'w--current'
    tabActive = 'w--tab-active'

    @$el.find('.tab-menu-link').removeClass(linkActive)
    @$el.find(".tab-menu-link[data-w-tab='#{tab}']").addClass(linkActive)

    @$el.find('.w-tab-pane').removeClass(tabActive)
    @$el.find(".w-tab-pane[data-w-tab='#{tab}']").addClass(tabActive)

  vectorMap: =>
    @$mapEl = $('.w-tab-pane[data-w-tab="map"]')

    # TODO: console.log 'render map called'
    values = _.object(
      _.map(countries, (i) ->
        [[i.iso3],[Math.floor((Math.random() * 100) + 1)]]
      )
    )
    console.log values
    @$mapEl.vectorMap(
      map: 'world_mill_en'
      series:
        regions: [
          values: values
          scale: ['red', 'blue']
          normalizeFunction: 'polynomial'
        ]
      regionsSelectable: true
      regionsSelectableOne: true
      # focusOn: region: 'gb'
      onRegionSelected: (ev, code) =>
        console.log(code)
        @zoomToRegion(code)
    )
    @mapObject = @$mapEl.vectorMap('get', 'mapObject')

  zoomToRegion: (code) =>
    @mapObject.setFocus(region: code, animate: true)

  prepareDataForMap: =>
    mapData = {}
    locationData = @collection.prepareFilterGroupForType('host_location')
    locationData.forEach( (i) =>
      mapData[i.value.toUpperCase()] = 
        activeCount: i.activeCount
        fillKey: _.keys(@fills)[_.random(0, _.keys(@fills).length)]
    )
    mapData

  calculateFillColours: (value, upper, lower) ->


