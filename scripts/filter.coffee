_ = require 'underscore'

class Filter
  constructor: (type, text) ->
    throw "Incorrect filter type" unless _.include(@types, type)
    return unless text
    @text = text
    @type = type

  filter: ->
    _.map(@splitComma(@text), (term) =>
      matched = _.filter(this[@type], (el) ->
        el.name.match(term)
      )
      if matched[0]
        matched[0].short
      else
        console.log("Can't match: '#{term} for '#{@type} type")
    )

  types: ['region', 'thematic_focus', 'partner_type']

  partner_type: [
      {name:'International cooperation / development agencies', short: 'international_cooperation_development_agencies'}, 
      {name:'International cooperation/development agencies', short: 'international_cooperation_development_agencies'}, 
      {name:'Regional / inter-governmental organizations', short: 'regional_inter_governmental_organizations'}, 
      {name:'Regional/Inter-governmental organizations', short: 'regional_inter_governmental_organizations'}, 
      {name:'National governments', short: 'national_governments'}, 
      {name:'Sub-national governments', short: 'sub_national_governments'}, 
      {name:'CSO', short: 'cso'}, 
      {name:'CSOs', short: 'cso'}, 
      {name:'Academia', short: 'academia'}, 
      {name:'Private sector',short: 'private_sector'}
    ]

  region: [
    {name: 'Latin America & Caribbean', short: 'lac'},
    {name: 'Africa', short: 'africa'},
    {name: 'Asia & Pacific', short: 'asia_pacific'},
    {name: 'Arab States', short: 'arab_states'},
    {name: 'Europe & CIS', short: 'europe_cis'},
    {name: 'ECIS', short: 'europe_cis'}
  ]

  thematic_focus: [
    {name:'Sustainable development', short: 'sustainable_development'},
    {name:'Resilience building', short: 'resilience_building'},
    {name:'Inclusive and effective democratic governance', short: 'inclusive_and_effective_democratic_governance'},
  ]

  splitComma: (data) ->
    return unless data
    data.split(',').map (i) ->
      i.replace(/^\s+|\s+$/g,"")

  justWords: (term) ->
    return unless term
    term.replace (/\(|\)/g), ""

module.exports = Filter