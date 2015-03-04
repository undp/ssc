class MapView extends Backbone.View
  initialize: (options) ->
    throw "Missing contentView" unless options.contentView?
    _.defer @vectorMap # TODO: Replace with better map init event
    console.log @collection

  vectorMap: =>
    console.log 'doing map thing'
    @$mapEl = $('.w-tab-pane[data-w-tab="map"]')

    # TODO: console.log 'render map called'
    values = _.object(
      _.map(countries, (i) ->
        [[i.iso3],[Math.floor((Math.random() * 100) + 1)]]
      )
    )

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