fs = require 'fs'

fs.readFileSync('/_site/data.json', (data) ->
  console.log data
)