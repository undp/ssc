class Countries extends Backbone.Collection
  model: Country

  search: (term) ->
    found = @_searchForTermInField(term, 'name') || 
            @_searchForTermInField(term, 'terr_name') ||
            @_searchForTermInField(term, 'map_name')

    return console.info("No country match found for '#{term}'") unless found?
    found

  _searchForTermInField: (term, field) =>
    results = @filter (country) ->
      re = new RegExp(term, 'i')
      country.get(field)?.match(re)

    if results.length == 0
      null
    else
      _.map(results, (i) -> i.toJSON())

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
