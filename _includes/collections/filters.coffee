class Filters extends Backbone.Collection
  model: Filter

  nameFromShort: (short) ->
    @get(short).get('name')

  search: (term) ->
    @filter (indice) ->
      re = new RegExp term, "i"
      indice.get('name').match re
