class MapView extends Backbone.View

  initialize: (options) ->
    throw "Missing parentView" unless options.parentView?
    _.defer @vectorMap # TODO: Replace with better map init event

  vectorMap: =>
    @$el = $('.w-tab-pane[data-w-tab="map"]')

    # TODO: console.log 'render map called'
    @values = @prepareDataForMap()
    console.dir @values


    @$el.vectorMap(
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
        @clickRegion(code)
      onRegionOver: (ev, code) =>
    )
    @mapObject = @$el.vectorMap('get', 'mapObject')
    window.m = @
    window.mo = m.mapObject
    @maxScale = @mapObject.scale

  clickRegion: (code) =>
    if @selectedRegionCode == code # TODO: Too unreliable as a check - need to refer to viewModel
      @deselectRegion(code)
    else
      @selectRegion(code)

  selectRegion: (code) =>
    @mapObject.clearSelectedRegions()
    @mapObject.tip.hide()
    @mapObject.setSelectedRegions(code)
    @mapObject.setFocus(regions: [code], animate: true)
    @selectedRegionCode = code

    # TODO: Use events instead?
    country = app.countries.searchByShort(code)
    if country?
      id = country.id.toLowerCase()
      @collection.addFilter(name: 'host_location', value: id)

    @mapObject.resize()
    
  deselectRegion: (code) =>
    @selectedRegionCode = ''
    @mapObject.clearSelectedRegions()
    @resetZoom()

    # TODO: Use events instead?
    country = app.countries.searchByShort(code)
    if country?
      id = country.id.toLowerCase()
      @collection.removeFilter(name: 'host_location', value: id)

  resetZoom: ->
    @mapObject.setFocus 
      scale: @maxScale
      x: 0
      y: 0
      animate: true

  prepareDataForMap: ->
    locationCounts = @collection.prepareFilterGroupForType('host_location')

    data = {}
    app.countries.map( (country) ->
      iso3 = country.get('iso3').toLowerCase()
      map_short = country.get('map_short')

      hasValue = _.findWhere(locationCounts, value: iso3)
      activeCount = hasValue?.activeCount || 0
      
      data[map_short] = activeCount
    )
    data



