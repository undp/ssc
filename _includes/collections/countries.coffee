class Countries extends Backbone.Collection
  url: 'api/countries.json'

  initialize: (options) ->

  findByIso3: (iso3) ->
    @findWhere(iso3: iso3.toUpperCase())

  toName: (iso3) ->
    found = @findByIso3(iso3)
    if found
      found.get('name')
