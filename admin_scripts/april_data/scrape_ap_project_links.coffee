fs      = require 'fs'
_       = require 'underscore'
_.str   = require 'underscore.string'
async   = require 'async'
request = require 'request'
cheerio = require 'cheerio'

SUFFIX = 'all'

class Process
  constructor: ->
    undpCountryOfficeLinks = JSON.parse(fs.readFileSync(__dirname + "/../source/undp_country_office_links_#{SUFFIX}.json", encoding: 'utf8'))
    links = @_filterCountries undpCountryOfficeLinks
    # @_testUrls(@_createContentRootUrls(links))
    # return
    rootUrls = @_createContentRootUrls(links)

    countryThemePages = @_createCountryThemePagesFrom(rootUrls)

    async.map countryThemePages, @_getAllProjectsForCountry, (err, results) =>
      throw new Error(err) if err?
      console.log 'finished getting all'
      fs.writeFileSync("scraped_#{SUFFIX}.json", JSON.stringify(results))

  _filterCountries: (undpCountryOfficeLinks) ->
    @_removeNotEnglish(@_removeIgnored(undpCountryOfficeLinks))

  _removeIgnored: (links) ->
    result = _.filter(links, (link) -> !link.ignore)
    console.log '\nIgnored:\n======='
    console.log _.map(_.difference(links, result), (i) -> "#{i.country}").join("\n")
    result

  _removeNotEnglish: (links) ->
    result = _.filter(links, (link) -> !link.language?)
    console.log '\nNot English:\n======='
    console.log _.map(_.difference(links, result), (i) -> "#{i.country}: #{i.language}").join("\n")
    console.log "\n\n\n"
    result
  # 
  # PROJECT TITLES
  # 
  _getAllProjectsForCountry: (countryThemePagesArray, callback) =>
    async.map countryThemePagesArray.themePages, @_getProjectTitlesFrom, (err, results) =>
      console.log 'Processed', countryThemePagesArray.country
      callback(err) if err?
      callback(null, 
        country: countryThemePagesArray.country
        themes: results
      )

  _getProjectTitlesFrom: (themePage, callback) ->
    request(themePage.page, (err, resp, html) ->
      if err?
        console.log 'Problem with', themePage.page
        return null
      else
        $ = cheerio.load(html)
        projects = _.map $('.teaser li'), (element) -> 
          $el = $(element)
          return {
            title: $el.find('.teaser-title').text()
            url: $el.find('a')[0].attribs.href
            description: $el.find('.teaser-description').text()
          }

      results = {
        theme: themePage.theme
        projects: projects
      }
      callback(null, results)
    )
      



  # 
  # THEME PAGES
  # 
  _createCountryThemePagesFrom: (rootUrls) =>
    _.map rootUrls, (rootUrl) =>
      country: rootUrl.country
      themePages: @_createThemePageUrlsForRoot(rootUrl.url)

  _createThemePageUrlsForRoot: (rootUrl) ->
    themes = ['poverty_reduction', 'democratic_governance', 'crisis_prevention_and_recovery', 'environment_and_energy', 'womens_empowerment']
    _.map themes, (theme) ->
      theme: theme
      page: "#{rootUrl}/en/home/operations/projects/#{theme}.html"



  # 
  # ROOT URLS
  # 

  _createContentRootUrls: (array) ->
    _.map(array, (link) =>
      if link.webclue?
        name = link.webclue
      else
        name = link.country
      
      return {
        country: link.country
        url: @_createUrlForCountryName(name)
      }
    )

  _createUrlForCountryName: (countryName) ->
    nameForUrl = _.str.underscored(countryName.toLowerCase()).replace(/\s/g, '')
    root = "http://www.undp.org"
    "#{root}/content/#{nameForUrl}"


  # 
  # UTILS
  # 
  
  _testUrls: (array) ->
    async.map array, (link, callback) =>
      root = "#{link.url}/en/home.html"

      request(root, (err, response, html) =>
        if err?
          console.log '!! Problem with:', link.url
          callback(err)
        else
          if @_countryContentFound(html)
            callback(null)
          else
            callback(null, link.url + ' XXX FAILURE XXX')
      )

    , (err, results) ->
      console.log('some error', err) if err?
      console.log 'Results:', _.compact results

  _countryContentFound: (html) ->
    $ = cheerio.load(html)
    $('.title-story').text() != 'The page you requested cannot be found'

new Process




# "#{root}content/#{country}/en/home/operations/projects/poverty_reduction.html"
# "#{root}content/#{country}/en/home/operations/projects/democratic_governance.html"
# "#{root}content/#{country}/en/home/operations/projects/crisis_prevention_and_recovery.html"
# "#{root}content/#{country}/en/home/operations/projects/environment_and_energy.html"
# "#{root}content/#{country}/en/home/operations/projects/womens_empowerment.html"