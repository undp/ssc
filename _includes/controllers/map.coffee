class MapController
  constructor: ->
    @styleOptions = app.mapStyles

  initializeMap: ->
    mapOptions = {
      center: { lat: 2.9, lng: 342}
      zoom: 3
      style: @styleOptions
    }

    app.map = new google.maps.Map(document.getElementById('map'), mapOptions)
