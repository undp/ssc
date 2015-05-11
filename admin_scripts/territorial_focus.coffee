# Add territorial focus to countries
# 

fs = require 'fs'
_  = require 'underscore'

countries     = JSON.parse(fs.readFileSync(__dirname + '/../_includes/data/countries.json', encoding: 'utf8'))
territorial_focus = JSON.parse(fs.readFileSync(__dirname + '/source/territorial_focus.json', encoding: 'utf8'))

_.chain(territorial_focus)
  .each (focus) =>
    country = _.findWhere(countries, name: focus.location)
    if country?
      country.territorial_focus = focus.territorial_focus
    else
      console.log 'Not found for', focus.location
  .value()

fs.writeFileSync __dirname + '/../_includes/data/countries_tf.json', JSON.stringify(countries)
console.log 'done'