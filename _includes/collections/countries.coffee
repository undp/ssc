class Countries extends Backbone.Collection
  model: Country

  searchByShort: (mapShort) ->
    @findWhere(map_short: mapShort.toUpperCase())

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

  # TODO: Remove unused methods
  
  # nameFromIso3: (iso3) ->
  #   @findWhere(iso3: iso3.toUpperCase())

  # nameFromMapShort: (mapShort) ->
  #   @findWhere(map_short: mapShort.toUpperCase())?.get('name')

  # shortFromIso3: (iso3) ->
  #   @findWhere(iso3: iso3.toUpperCase())?.get('map_short')

  # isoFromName: (name) ->
  #   return unless name
  #   try
  #     @findWhere(name: name).get('iso3')
  #   catch e
  #     throw "Country not found for #{name}"
  #   