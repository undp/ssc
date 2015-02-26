class Filters extends Backbone.Collection
  model: Filter

  addCountries: ->
    _.each window.countries, (country) =>
      @add
        name: country.name
        short: country.iso3.toLowerCase()
        type: 'country'
        forFilter: 'location'

  nameFromShort: (short) ->
    got = @get(short)
    if got
      got.get('name')
    else
      throw new Error "Can't find valid indice for #{short}"

  search: (term) ->
    @filter (indice) ->
      re = new RegExp term, "i"
      indice.get('name').match re

  validFilters: (filterName, filterValue) ->
    return true unless filterName? and filterValue?
    
    filterName = 'country' if _.contains(['host_location'], filterName)

    new Backbone.Collection(
      @where type: filterName
    ).where(
      short: filterValue
    ).length > 0

