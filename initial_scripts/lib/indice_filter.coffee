fs = require 'fs'
_  = require 'underscore'

class FilterIndice
  types: ['region', 'thematic_focus', 'partner_type']

  constructor: ->
    console.log 'created FilterIndice'
    @configureTypes()

  configureTypes: ->
    @indices = JSON.parse(fs.readFileSync('../_includes/data/indices.json', encoding: 'utf8'))

    _.each @types, (type) =>
      @[type] = @indices[type].values

  filter: (type, text) ->
    throw 'Incorrect filter type' unless _.include(@types, type)
    throw 'No search text given' unless text

    _.map(@splitComma(text), (term) =>
      matched = _.filter(this[type], (el) ->
        term.match(el.name)
      )
      if matched[0]
        matched[0].short
      else
        console.log @['thematic_focus']
        console.error("Can't match: '#{term}' for type '#{type}'")
    )

  splitComma: (data) ->
    return unless data
    data.split(',').map (i) ->
      i.replace(/^\s+|\s+$/g,"")

  justWords: (term) ->
    return unless term
    term.replace (/\(|\)/g), ""

module.exports = FilterIndice