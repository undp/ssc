class MapView extends Backbone.View
  initialize: (options) ->
    throw "Missing contentView" unless options.contentView?
    _.defer @vectorMap # TODO: Replace with better map init event

  vectorMap: =>
    @$mapEl = $('.w-tab-pane[data-w-tab="map"]')

    # TODO: console.log 'render map called'
    @values = {}
    _.each(countries, (i) =>
      @values[i.map_short] = _.random(0,10)
    )

    @$mapEl.vectorMap(
      map: 'world_mill_en'
      backgroundColor: 'white'
      series:
        regions: [
          values: @values
          scale: ['#95B9D7', '#1057A7']
          normalizeFunction: 'polynomial'
        ]
      regionsSelectableOne: true
      regionStyle:
        selected:
          fill: '#f7be00'
      onRegionClick: (ev, code) =>
        @zoom(code)
      onRegionOver: (ev, code) =>
    )
    @mapObject = @$mapEl.vectorMap('get', 'mapObject')
    window.m = @
    window.mo = m.mapObject
    @maxScale = @mapObject.scale

  zoom: (code) =>
    if @selectedRegionCode == code
      @selectedRegionCode = ''
      @mapObject.clearSelectedRegions()
      @resetZoom()
    else
      @mapObject.clearSelectedRegions()
      @mapObject.tip.hide()
      @mapObject.setSelectedRegions(code)
      @mapObject.setFocus(regions: [code], animate: true)
      @selectedRegionCode = code

  resetZoom: ->
    @mapObject.setFocus 
      scale: @maxScale
      x: 0
      y: 0
      animate: true

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