class Countries extends Backbone.Collection
  model: Country

  search: (term) ->
    found = @searchForTermInField(term, 'name') || 
            @searchForTermInField(term, 'terr_name') ||
            @searchForTermInField(term, 'map_name')

    return console.info("No country match found for '#{term}'") unless found?
    found
      
  searchForTermInField: (term, field) =>
    results = @filter (country) ->
      re = new RegExp(term, 'i')
      country.get(field)?.match(re)

    if results.length == 0
      null
    else
      _.map(results, (i) -> i.toJSON())

  nameFromIso3: (iso3) ->
    @findWhere(iso3: iso3.toUpperCase())

  nameFromMapShort: (mapShort) ->
    @findWhere(map_short: mapShort.toUpperCase())

  isoFromName: (name) ->
    return unless name
    try
      @findWhere(name: name).get('iso3')
    catch e
      throw "Country not found for #{name}"
    