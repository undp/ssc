class Countries extends Backbone.Collection
  model: Country
  
  nameFromIso2: (iso2) ->
    @findWhere(iso2: iso2.toUpperCase())

  nameFromIso3: (iso3) ->
    @findWhere(iso3: iso3.toUpperCase())

  nameFromIso: (iso) ->
    return unless iso and iso.length > 1 and iso.length < 4
    try
      @["nameFromIso#{iso.length}"](iso).get('name')
    catch
      throw "Country not found for #{iso}"

  isoFromName: (name) ->
    return unless name
    try
      @findWhere(name: name).get('iso3')
    catch e
      throw "Country not found for #{name}"
    