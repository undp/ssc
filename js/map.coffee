---
---
baseurl = "{{ site.baseurl }}"
app = window.app = {}
styleOptions = {% include map_styles.json %}
operatingUnits = {% include data/operating_units.json %}



# $(document).ready ->
initializeMap = ->
  mapOptions = {
    center: { lat: 2.9, lng: 342},
    zoom: 3
  }
  mapOptions.styles = styleOptions
  app.map = new google.maps.Map(document.getElementById('map'),mapOptions)

google.maps.event.addDomListener(window, 'load', initializeMap)

