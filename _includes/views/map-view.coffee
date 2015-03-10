class MapView extends Backbone.View

  initialize: ->
    @listenTo @collection, 'reset', @render
    @listenTo @collection, 'filters:add', @render
    @listenTo @collection, 'filters:remove', @render
    @listenTo @collection, 'filters:reset', @render

    # `preloadData` is bootstrapped into index.html
    @countries = new MapCountries(preloadData.countries) 

  render: ->
    return unless @mapObject?
    @_updateValues()
    @_zoomToActiveRegions()
    @mapObject.updateSize()

  setActive: ->
    @_createMap() unless @mapObject?
    @mapObject.updateSize()

  _zoomToActiveRegions: ->
    activeRegions = _.map(@collection.getLocations(), (location) =>
      @countries.mapShortFromIso3(location)
    )

    @mapObject.setFocus(regions: activeRegions, animate: true)

  _createMap: =>
    values = @_prepareDataForMap()

    @$el.vectorMap(
      map: 'world_mill_en'
      backgroundColor: 'white'
      series:
        regions: [
          values: values
          scale: ['#EEEEEE', '#1057A7']
          normalizeFunction: 'polynomial'
        ]
      regionsSelectableOne: true
      regionStyle:
        selected:
          fill: '#f7be00'
      onRegionClick: (ev, code) =>
        @_clickRegion(code)
      onRegionTipShow: (e, el, code) =>
        countryIso3 = @countries.iso3FromMapShort(code)
        activeCount = app.projects.projectCountForFacetValue('host_location', countryIso3)
        el.html("#{el.html()} (#{activeCount} projects)") if activeCount isnt 0
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
    # @mapObject.setFocus(regions: [code], animate: true)
    @selectedRegionCode = code

    country = @countries.iso3FromMapShort(code)
    @collection.addFilter(name: 'host_location', value: country.toLowerCase()) if country?

    @mapObject.resize()
    
  _deselectRegion: (code) =>
    @selectedRegionCode = ''
    @mapObject.clearSelectedRegions()
    @_resetZoom()

    country = @countries.iso3FromMapShort(code)
    @collection.removeFilter(name: 'host_location', value: country.toLowerCase()) if country?

  _resetZoom: ->
    @mapObject.setFocus 
      scale: @maxScale
      x: 0
      y: 0
      animate: true

  _prepareDataForMap: ->
    locationCounts = @collection.prepareFilterGroupForType('host_location')

    data = {}
    @countries.map( (country) ->
      iso3 = country.get('iso3').toLowerCase()
      map_short = country.get('map_short')

      hasValue = _.findWhere(locationCounts, value: iso3)
      activeCount = hasValue?.activeCount || 0
      
      data[map_short] = activeCount
    )
    data



