fs = require 'fs'
_ = require 'underscore'
_.str = require 'underscore.string'
async = require 'async'
MatchingTerm = require './lib/matching_term'

class Process
  constructor: ->
    @countries     = JSON.parse(fs.readFileSync(__dirname + '/../_includes/data/countries_tf.json', encoding: 'utf8'))
    @projects      = JSON.parse(fs.readFileSync(__dirname + '/june_2015_data/SSC_additional_data_June_2015.txt', encoding: 'utf8')).rows
    @template      = fs.readFileSync(__dirname + '/lib/project_file_template._', encoding: 'utf8')

    # console.log @projects.length
    # return
    # MatchingTerm#find takes `type` and `text` and returns matching term
    @matchingTerm = new MatchingTerm
    console.log "Loaded #{@projects.length} projects"

    processed = @processAll(@projects)
    @writeAll(processed)
    console.log("Created project files for #{processed.length} projects - located in '_ssc_projects'")

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
      "country"           : @normalise_location(project.country_iso3),
      "region"            : project.region,#@normalise('region', project.region),
      # SSC intervention
      "undp_role_type"    : @normalise('undp_role_type', project.undp_role_type),
      "thematic_focus"    : [project.thematic_focus],
      "ssc_description"   : project.ssc_description,
      "territorial_focus" : @normalise_territorial_focus(project.country_iso3),
      "partner_type"      : [project.partner_type], #@normalise('partner_type', project.partner_type),
      # Links
      "project_link"      : project.project_link
      "import_source"     : 'june_2015'
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

  normalise_location: (iso3) ->
    return [iso3.toUpperCase() if iso3?]

  normalise_territorial_focus: (iso3) ->
    return [] if !iso3?
    country = _.findWhere @countries, iso3: iso3.toUpperCase()
    if country? and country.territorial_focus?
      country.territorial_focus
    else
      console.log "#{iso3}: not matched for territorial_focus"
      return

  splitComma: (data) ->
    return unless data
    data.split(',').map (i) ->
      i.replace(/^\s+|\s+$/g,"")

  justWords: (term) ->
    return unless term
    term.replace (/\(|\)/g), ""

module.export = Process
debugger
s = new Process
