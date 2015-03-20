fs = require 'fs'
_ = require 'underscore'
_.str = require 'underscore.string'
async = require 'async'

MatchingTerm = require './lib/matching_term'

class Process
  constructor: ->
    @countries     = JSON.parse(fs.readFileSync(__dirname + '/../_includes/data/countries.json', encoding: 'utf8'))
    @projects      = JSON.parse(fs.readFileSync(__dirname + '/source/refine_projects_export.json', encoding: 'utf8')).rows
    @template      = fs.readFileSync(__dirname + '/lib/project_file_template._', encoding: 'utf8')

    # MatchingTerm#find takes `type` and `text` and returns matching term
    @matchingTerm = new MatchingTerm

    console.log "Loaded #{@projects.length} projects"

    processed = @processAll(@projects)
    @writeAll(processed)
    console.log("Created project files for #{@projects.length} projects - located in '_ssc_projects'")

  processAll: (projects) ->
    _.map projects, (project) =>
      @processEach(project)

  processEach: (project) ->
    @pid = project.project_id
    {
      # IDs
      "project_id"        : project.project_id,
      "open_project_id"   : project.open_project_id,
      # Project description
      "project_title"     : project.project_title,
      "project_objective" : project.project_objective,
      "scale"             : @normalise('scale', project.scale),
      "country"           : @normalise_location(project.location),
      "region"            : @normalise('region', project.region),
      # SSC intervention
      "undp_role_type"    : @normalise('undp_role_type', project.undp_role_type),
      "thematic_focus"    : @normalise('thematic_focus', project.thematic_focus),
      "ssc_description"   : project.ssc_description,
      "territorial_focus" : @normalise('territorial_focus', project.territorial_focus),
      "partner_type"      : @normalise('partner_type', project.partner_type),
      # Links
      "project_link"      : project.project_link
    }

  writeAll: (data) ->
    _.each(data, (project) =>
      @writeEach(project)
    )

  writeEach: (project) ->
    compiled = _.template(@template)
    content = compiled(project)
    fs.writeFileSync(__dirname + "/../_ssc_projects/#{project.project_id}.txt", content)

  normalise: (type, text) ->
    return unless text
    @matchingTerm.find(type, text)

  normalise_location: (location) ->
    _.map(@splitComma(location), (i) =>
      @match_similar_country_name(i)
    )

  match_similar_country_name: (term) ->
    term_escaped = term.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&")
    re = new RegExp("^" + term_escaped,"i")
    matches = _.select(@countries, (i) ->
      i.name.match re
    )
    console.warn "Can't find match for #{term} [#{@pid}]" if matches.length == 0
    matches[0].iso3 if matches.length > 0

  splitComma: (data) ->
    return unless data
    data.split(',').map (i) ->
      i.replace(/^\s+|\s+$/g,"")

  justWords: (term) ->
    return unless term
    term.replace (/\(|\)/g), ""

module.export = Process
s = new Process
