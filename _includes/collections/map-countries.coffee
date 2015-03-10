class MapCountries extends Backbone.Collection
  model: MapCountry

  mapShortFromIso3: (iso3) ->
    found = @findWhere(iso3: iso3.toUpperCase())
    if found?
      found?.get('map_short') || console.warn "No mapShort code found for #{found.get('name')}"
    else
      console.warn "No Country found for #{iso3}"

  iso3FromMapShort: (mapShort) ->
    found = @findWhere(map_short: mapShort.toUpperCase())
    if found?
      found?.get('iso3') || console.warn "No iso3 code found for #{found.get('name')}"
    else
      console.warn "No Country found for #{mapShort}"
