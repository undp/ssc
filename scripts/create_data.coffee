fs = require 'fs'
_ = require 'underscore'
_.str = require 'underscore.string'

class Start
  constructor: ->
    fs.readFile('api/countries.json', encoding: 'utf8', (err, data) =>
      if err then throw err
      @countries = JSON.parse(data)
    
      fs.readFile('api/or_projects_export.json', encoding: 'utf8', (err, data) =>
        if err then throw err
        projects = JSON.parse(data)
        # projects = projects.slice(0, 10) # TESTING QUICKLY
        processed = @processAll(projects)
        @writeAll(processed)
        console.log('done')
      )
    )

  processAll: (projects) ->
    _.map projects, (project) =>
      @process(project)

  process: (project) ->
    {
      # IDs
      "project_id": project.project_id,
      "open_project_id": project.open_project_id,
      # Project description
      "project_title": project.project_title,
      "project_objective": project.project_objective,
      "scale": @normalise_scale(project.scale),
      "host_location": @normalise_location(project.location),
      "region": @normalise_region(project.region),
      # SSC intervention
      "undp_role_type": @normalise_undp_role_type(project.undp_role_type),
      "thematic_focus": @normalise_thematic_focus(project.thematic_focus),
      "ssc_description": project.ssc_description,
      "territorial_focus": project.territorial_focus,
      "partner_location": @normalise_partner_location(project.ssc_description),
      "partner_type": @normalise_partner_type(project.partner_type),
      # Links
      "project_link": project.project_link
    }

  writeAll: (data) ->
    # fs.writeFileSync('api/projects.json', JSON.stringify(@processed))
    _.each(data, (project) =>
      @writeEach(project)
    )

  writeEach: (project) ->
    template = fs.readFileSync('scripts/project_file_template._', encoding: 'utf8')
    compiled = _.template(template)
    content = compiled(project)
    fs.writeFileSync "_ssc_data/#{project.project_id}.txt", content

  normalise_scale: (scale) ->
    return unless scale
    scale.toLowerCase()

  normalise_location: (location) ->
    @host_location = _.map(@splitComma(location), (i) =>
      @match_country_name(i)
    )

  normalise_region: (region_text) ->
    return unless region_text
    regions = [
      {name: 'Latin America & Caribbean', short: 'lac'},
      {name: 'Africa', short: 'africa'},
      {name: 'Asia & Pacific', short: 'asia_pacific'},
      {name: 'Arab States', short: 'arab_states'},
      {name: 'Europe & CIS', short: 'europe_cis'},
      {name: 'ECIS', short: 'europe_cis'}
    ]
    _.map(@splitComma(region_text), (term) ->
      matched = _.filter(regions, (region) ->
        region.name.match(region_text)
      )
      if matched[0]
        matched[0].short
    )

  normalise_undp_role_type: (data) ->
    _.map(@splitComma(data), (i) ->
      _.str.underscored(i)
    )

  normalise_thematic_focus: (data) ->
    themes = ['Sustainable development', 'Resilience building', 'Inclusive and effective democratic governance']
    _.map(@splitComma(data), (term) =>
      matched = _.filter(themes, (theme) ->
        term.match(theme)
      )
      @justWords(_.str.underscored(matched[0]))
    )

  normalise_partner_location: (data) ->
    return unless data
    cleaned = data.split(" ").map( (i) ->
      i.replace(/\W/g, '')
    )
    partners = _.chain(cleaned)
    .map((i) => @match_exact_country_name(i))
    .compact().uniq().value()
    _.difference(partners, @host_location)

  normalise_partner_type: (data) ->
    partner_types = ['International cooperation / development agencies', 'Regional / inter-governmental organizations', 'National governments', 'Sub-national governments', 'CSO', 'Academia', 'Private sector']
    _.map(@splitComma(data), (term) =>
      matched = _.filter(partner_types, (type) ->
        term.match(type)
      )
      @justWords(_.str.underscored(matched[0]))
    )

  splitComma: (data) ->
    return unless data
    data.split(',').map (i) ->
      i.replace(/^\s+|\s+$/g,"")

  justWords: (term) ->
    return unless term
    term.replace (/\(|\)/g), ""

  match_country_name: (term) ->
    re = new RegExp("^" + term,"i")
    matches = _.select(@countries, (i) ->
      i.name.match re
    )
    matches[0].iso3 if matches.length > 0

  match_exact_country_name: (term) ->
    matches = _.select(@countries, (i) ->
      re = new RegExp("^#{i.name}$","i")
      term.match re
    )
    matches[0].iso3 if matches.length > 0

s = new Start
