# Creates a tabular list of all countries (for use in docs)
# 
# 

fs = require 'fs'
_  = require 'underscore'

countries = JSON.parse(fs.readFileSync(__dirname + '/../_includes/data/countries.json', encoding: 'utf8'))
countries = _.sortBy(countries,'name')
output = ''

output += "#### Countries\n"
output += 'Name | ISO3 | Coordinates (centre)  \n---|---|---\n'

_.each countries, (country) ->
  output += "#{country.name} | #{country.iso3} | #{country.lat}, #{country.lon}\n"
output += '\n'

fs.writeFileSync(__dirname + '/tabulated_countries.txt', output)

console.log 'Done'



