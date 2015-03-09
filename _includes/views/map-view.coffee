class MapView extends Backbone.View

  initialize: ->
    @listenTo @collection, 'reset', @_updateValues
    @listenTo @collection, 'filters:add', @_updateValues
    @listenTo @collection, 'filters:remove', @_updateValues
    @listenTo @collection, 'filters:reset', @_updateValues

    _.defer @_createMap # TODO: Replace with better map init event

  render: ->
    @_updateValues() if @mapObject?

  setActive: ->
    @mapObject?.updateSize()

  _createMap: =>
    values = @_prepareDataForMap()

    @$el.vectorMap(
      map: 'world_mill_en'
      backgroundColor: 'white'
      series:
        regions: [
          values: values
          scale: ['#95B9D7', '#1057A7']
          normalizeFunction: 'polynomial'
        ]
      regionsSelectableOne: true
      regionStyle:
        selected:
          fill: '#f7be00'
      onRegionClick: (ev, code) =>
        @_clickRegion(code)
      onRegionOver: (ev, code) =>
    )
    @mapObject = @$el.vectorMap('get', 'mapObject')
    @maxScale = @mapObject.scale # TODO: Handle zoom and resizing better
    window.m = @ # TODO: Remove debugging global

  _updateValues: ->
    values = @_prepareDataForMap()
    @mapObject.series.regions[0].setValues(values)

  _clickRegion: (code) =>
    if @selectedRegionCode == code # TODO: Too unreliable as a check - need to refer to viewModel
      @_deselectRegion(code)
    else
      @_selectRegion(code)

  _selectRegion: (code) =>
    @mapObject.clearSelectedRegions()
    @mapObject.tip.hide()
    @mapObject.setSelectedRegions(code)
    @mapObject.setFocus(regions: [code], animate: true)
    @selectedRegionCode = code

    # TODO: Use events instead to add/remove filters?
    country = app.countries.searchByShort(code)
    if country?
      id = country.id.toLowerCase()
      @collection.addFilter(name: 'host_location', value: id)

    @mapObject.resize()
    
  _deselectRegion: (code) =>
    @selectedRegionCode = ''
    @mapObject.clearSelectedRegions()
    @_resetZoom()

    # TODO: Use events instead to add/remove filters?
    country = app.countries.searchByShort(code)
    if country?
      id = country.id.toLowerCase()
      @collection.removeFilter(name: 'host_location', value: id)

  _resetZoom: ->
    @mapObject.setFocus 
      scale: @maxScale
      x: 0
      y: 0
      animate: true

  _prepareDataForMap: ->
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



