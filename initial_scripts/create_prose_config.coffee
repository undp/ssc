fs = require 'fs'
_ = require 'underscore'
yaml = require 'js-yaml'

class CreateProseConfig
  constructor: ->
    @indices = JSON.parse(fs.readFileSync('../_includes/data/indices.json', encoding: 'utf8'))
    countries = JSON.parse(fs.readFileSync('../_includes/data/countries.json', encoding: 'utf8'))
    
    @indices = _.flatten [@indices, countries]
    console.log "Loaded #{@indices.length} indices"

    processed = @process()
    @write(processed)
    console.log("Created `_prose.yml` config file")

  process: ->
    data =
      undp_role_type    : 'undp_role_type'
      thematic_focus    : 'thematic_focus'
      territorial_focus : 'territorial_focus'
      scale             : 'scale'
      region            : 'region'
      country           : _.filter(@indices, {})
      partner_type      : 'partner_type'

  write: (data) ->
    compiled = _.template(@template)
    content = compiled(data)
    fs.writeFileSync "../_prose.yml", content


new CreateProseConfig