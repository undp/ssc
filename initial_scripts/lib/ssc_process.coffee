fs = require 'fs'
_  = require 'underscore'

class ProcessFilter
  types: ['region', 'thematic_focus', 'partner_type']

  constructor: ->
    console.log 'created ProcessFilter'
    @configureTypes()

  configureTypes: ->
    @indices = JSON.parse(fs.readFileSync('../_includes/data/indices.json', encoding: 'utf8'))

    @partner_type   = _.where @indices, type: 'partner_type'
    @region         = _.where @indices, type: 'region'
    @thematic_focus = _.where @indices, type: 'thematic_focus'

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
        console.error("Can't match: '#{term}' for type '#{@type}'")
    )

  splitComma: (data) ->
    return unless data
    data.split(',').map (i) ->
      i.replace(/^\s+|\s+$/g,"")

  justWords: (term) ->
    return unless term
    term.replace (/\(|\)/g), ""

module.exports = ProcessFilter