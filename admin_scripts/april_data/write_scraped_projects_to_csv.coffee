fs  = require 'fs'
_   = require 'underscore'
csv = require 'csv-line'

SUFFIX = 'all'

class Process
  constructor: ->
    data = JSON.parse(fs.readFileSync(__dirname + "/scraped_#{SUFFIX}.json", encoding: 'utf8'))
    outputFile = "scraped_projects_#{SUFFIX}.csv"
    @_prepareFile(outputFile)

    _.each data, (countryData) -> # Countries
      country = countryData.country
      _.each countryData.themes, (themeData) -> # Themes
        theme = themeData.theme
        _.each themeData.projects, (projectData) -> # Projects
          line = csv.encode([country, theme, projectData.title, projectData.url, projectData.description])
          fs.appendFileSync outputFile, line + "\n"
          console.log 'done line'

  _prepareFile: (file) ->
    fs.writeFileSync(file, "Country,Theme,ProjectTitle,ProjectUrl,ProjectDescription\n")

new Process