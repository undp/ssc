class Countries extends Backbone.Collection
  url: '{{site.baseurl}}/api/countries.json'

  initialize: (options) ->

  findByIso2: (iso2) ->
    @findWhere(iso2: iso2.toUpperCase())

  findByIso3: (iso3) ->
    @findWhere(iso3: iso3.toUpperCase())

  IsoToName: (iso) ->
    return unless iso and iso.length
    try
      found = @["findByIso#{iso.length}"](iso)
    catch
      throw 'Country not found'
    if found
      found.get('name')
