fs = require 'fs'
_  = require 'underscore'

class MatchingTerm
  types: ['region', 'thematic_focus', 'partner_type']

  constructor: ->
    @configureTypes()

  configureTypes: ->
    @indices = JSON.parse(fs.readFileSync(__dirname + '/../../_includes/data/indices.json', encoding: 'utf8'))

    _.each @types, (type) =>
      @[type] = _.findWhere(@indices, type: type).values

  find: (type, text) ->
    throw 'No search text given' unless text

    if _.include(@types, type)
      @typeBased(type, text)
    else
      @["normalise_#{type}"](text)

  typeBased: (type, text) ->
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

  normalise_scale: (scale) ->
    return unless scale
    scale.toLowerCase()

  normalise_undp_role_type: (data) ->
    _.map(@splitComma(data), (i) ->
      _.str.underscored(i)
    )

  normalise_territorial_focus: (data) ->
    _.map(@splitComma(data), (i) ->
      _.str.underscored(i)
    )

  splitComma: (data) ->
    return unless data
    data.split(',').map (i) ->
      i.replace(/^\s+|\s+$/g,"")

  justWords: (term) ->
    return unless term
    term.replace (/\(|\)/g), ""

module.exports = MatchingTerm
