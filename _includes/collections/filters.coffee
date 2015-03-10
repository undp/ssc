class Filters extends Backbone.Collection
  model: Filter

  populate: (options) ->
    throw 'Missing indices' unless options.indices?
    throw 'Missing countries' unless options.countries?
    @_addIndices(options.indices)
    @_addCountries(options.countries)

  validFilters: (filterName, filterValue) ->
    return true unless filterName? and filterValue?
    
    new Backbone.Collection(
      @where type: filterName
    ).where(
      short: filterValue
    ).length > 0

  # FIND/SEARCH
  nameFromShort: (short) ->
    got = @get(short)
    if got?
      got.get('name')
    else
      console.info "Can't find valid Filter for '#{short}'"
      false

  search: (term) ->
    @filter (indice) =>
      re = new RegExp term, "i"
      indice.get('name').match re

  _addIndices: (indices) ->
    _.each indices, (indice) =>
      _.each indice.values, (indiceEntry) =>
        @add
          name: indiceEntry.name
          short: indiceEntry.short
          type: indice.type
          filterTitle: indice.filterTitle

  _addCountries: (countries) ->
    _.each countries, (country) =>
      @add
        name: country.name
        short: country.iso3.toLowerCase()
        type: 'host_location'
        filterTitle: 'Country'
