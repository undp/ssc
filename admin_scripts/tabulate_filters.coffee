# Excluding countries, creates a tabular list of all filters (for use in docs)
# 
# 

fs = require 'fs'
_  = require 'underscore'

indices = JSON.parse(fs.readFileSync(__dirname + '/../_includes/data/indices.json', encoding: 'utf8'))

output = ''

_.each indices, (indice) ->
  output += "#### #{indice.filterTitle}\n"
  output += 'Short | Full \n---|---\n'

  _.each indice.values, (value) ->
    output += "`#{value.short}` | #{value.name}\n"
  output += '\n'

fs.writeFileSync(__dirname + '/tabulated_filters.txt', output)

console.log 'Done'



