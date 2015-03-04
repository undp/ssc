class Countries extends Backbone.Collection
  model: Country

  search: (term) ->
    found = @searchForTermInField(term, 'name') || 
            @searchForTermInField(term, 'terr_name')

    if found?
      _.map(found, (i) -> i.toJSON()) 
    else
      console.info "No country match found for '#{term}'" 
  
  searchForTermInField: (term, field) =>
    results = @filter (country) ->
      re = new RegExp(term, 'i')
      country.get(field).match(re)

    if results.length == 0
      null
    else
      results

  nameFromIso2: (iso2) ->
    @findWhere(iso2: iso2.toUpperCase())

  nameFromIso3: (iso3) ->
    @findWhere(iso3: iso3.toUpperCase())

  nameFromIso: (iso) ->
    return unless iso and iso.length > 1 and iso.length < 4
    found = @["nameFromIso#{iso.length}"](iso)
    found.get('name') if found

  isoFromName: (name) ->
    return unless name
    try
      @findWhere(name: name).get('iso3')
    catch e
      throw "Country not found for #{name}"
    