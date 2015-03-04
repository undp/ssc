_  = require 'underscore'
fs = require 'fs'

class Match
  constructor: ->
    @countries     = JSON.parse(fs.readFileSync(__dirname + '/source/original_countries.json', encoding: 'utf8'))
    pathsData      = JSON.parse(fs.readFileSync(__dirname + '/source/jvectormap_paths.json', encoding: 'utf8'))
    @paths = @createPathsArray(pathsData)
    
    console.log "Countries length: #{@countries.length}"
    console.log "Paths length: #{@paths.length}\n"

    # Find all countries for which there's an exact match between @paths#name and #countries#name
    console.log "Exact matches: #{@pathsWithExactCountryMatches().length}"
    console.log "Rough matches: #{@pathsWithCloseCountryMatches().length}"
    console.log "No matches: #{@pathsWithoutCountryMatches().length }\n"

    # console.log "Match type for first of @paths is #{@findMatch(@paths[0])}"

    # @presentCloseMatches()
    @process()

  process: ->
    _.map @paths, (path) =>
      matchType = @findMatch(path)

      if matchType == 'exact'
        country = @search(path.name)[0]
        console.log "Set short for #{country.name}[#{country.iso3}] to #{path.short}"
        @setShortForCountry(path.short, country.iso3)
      else if matchType == 'close'
        country = @search(path.name)[0]
        console.log "Probably set short for #{country.name}[#{country.iso3}] to #{path.short}"
        @setShortForCountry(path.short, country.iso3)
      else 
        # console.log "No match found for #{path.name}"

    fs.writeFileSync(__dirname + '/../_includes/data/countries.json', JSON.stringify(@countries))


  setShortForCountry: (short, iso3) ->
    _.findWhere(@countries, iso3: iso3).map_short = short

  presentCloseMatches: ->
    paths = @pathsWithCloseCountryMatches()
    _.each paths, (path) ->
      console.log 
        short: path.short
        name: path.name
  
  findMatch: (path) ->
    found = @search(path.name)
    if found?[0].name == path.name
      'exact'
    else if found? and !(found?[0].name == path.name)
      'close'
    else
      'none'

  pathsWithExactCountryMatches: ->
    _.filter @paths, (path) =>
      @findMatch(path) == 'exact'

  pathsWithCloseCountryMatches: ->
    _.filter @paths, (path) =>
      @findMatch(path) == 'close'

  pathsWithoutCountryMatches: ->
    _.filter @paths, (path) =>
      @findMatch(path) == 'none'

  createPathsArray: (pathsData) ->
    _.map(_.keys(pathsData), (key) ->
      short: key
      name: pathsData[key].name
    )

  search: (term) ->
    found = @searchForTermInField(term, 'name') || 
            @searchForTermInField(term, 'terr_name') ||
            @searchForTermInField(term, 'map_name')

    # return console.info("No country match found for '#{term}'") unless found?
    found
      
  searchForTermInField: (term, field) =>
    results = _.filter @countries, (country) ->
      re = new RegExp(term, 'i')
      country[field]?.match(re)

    if results.length == 0
      null
    else
      results

new Match