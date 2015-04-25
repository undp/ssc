# Takes export from OpenRefine of additional 469 projects
# Compares each title to the `output.json` from `compile_project_titles.coffee`
# 

fs = require 'fs'
_ = require 'underscore'
score = require 'string_score'

MATCH_CONFIDENCE        = 0.6
SOURCE_MATCH_FIELD      = 'project_title'
DESTINATION_MATCH_FIELD = 'project_description'

class Process
  constructor: ->
    @referenceCollection = @_prepareReferenceCollection()
    # Need to find matches for these projects
    @projectsToMatch = JSON.parse(fs.readFileSync(__dirname + "/469_export.json", 'utf8')).rows
    output = @_processAll(@projectsToMatch)
    @_write(output)

  _prepareReferenceCollection: ->
    # Scraped 1290 projects from UNDP country sites
    data = JSON.parse(fs.readFileSync(__dirname + "/scraped_all.json", 'utf8'))
    flatProjects = []
    _.each data, (countryData) -> # Countries
      country = countryData.country
      _.each countryData.themes, (themeData) -> # Themes
        theme = themeData.theme
        _.each themeData.projects, (projectData) -> # Projects
          flatProjects.push [country, theme, projectData.title, projectData.url, projectData.description]
    flatProjects

  _processAll: (projects) ->
    debugger
    _.chain(projects)
      .map (project) => 
        @_processProject(project)
      .filter (project) -> project.top_match_project_id?
      .value()

  _processProject: (project) ->
    name = project[SOURCE_MATCH_FIELD]
    matches = @_getScoresFor(name)
    topMatch = matches[0]
    return {
      searched_for            : name
      top_match_project_id    : topMatch?.project_id
      top_match_project_title : topMatch?.project_title
      top_match_project_descr : topMatch?.project_description
      top_match_confidence    : topMatch?.score
    }

  _write: (output) ->
    fs.writeFileSync(__dirname + "/matched_projects.json", JSON.stringify(output))
    console.log "\nWritten #{output.length} projects"

  # 
  # Scoring
  # 
  _getScoresFor: (name) =>
    debugger
    _.chain(@_matchTerm(name))
      .filter (match) -> match.score > MATCH_CONFIDENCE
      .sortBy (match) -> -match.score
      .value()

  _matchTerm: (term) =>
    process.stdout.write '.'
    
    result = _.map @referenceCollection, (reference_project) ->
      title = reference_project[2]
      score = Math.ceil(title.score(term) * 100) / 100
      return _.extend(score: score, reference_project)

    console.log result
    result

new Process