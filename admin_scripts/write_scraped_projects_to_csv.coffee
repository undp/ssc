fs  = require 'fs'
_   = require 'underscore'
csv = require 'csv-line'

SUFFIX = 'all'

class Process
  constructor: ->
    data = JSON.parse(fs.readFileSync(__dirname + "/scraped_#{SUFFIX}.json", encoding: 'utf8'))
    # fs.writeFileSync("scraped_projects_#{SUFFIX}.csv", encoded)
    outputFile = "scraped_projects_#{SUFFIX}.csv"
    @_prepareFile(outputFile)

    _.each data.slice(0,1), (countryData) -> # Countries
      # console.log countryData
      country = countryData.country
      # console.log country
      _.each countryData.themes, (themeData) -> # Themes
        theme = themeData.theme
        # console.log themeData
        _.each themeData.projects, (projectData) -> # Projects
          fs.appendFileSync country, theme, projectData.title, url

  _prepareFile: (file) ->
    fs.unlinkSync(file) # deletes

new Process