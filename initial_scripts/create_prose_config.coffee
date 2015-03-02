fs       = require 'fs'
_        = require 'underscore'
yaml     = require 'js-yaml'

class CreateProseConfig
  constructor: ->
    @indices = JSON.parse(fs.readFileSync('../_includes/data/indices.json', encoding: 'utf8'))
    countries = JSON.parse(fs.readFileSync('../_includes/data/countries.json', encoding: 'utf8'))
    
    @indices = _.flatten [@indices, countries]
    console.log "Loaded #{@indices.length} indices"

    processed = @process()
    @write(processed)
    console.log("Updated `_config.yml` based on `indices.json`")

  write: (data) ->
    existingConfig = yaml.safeLoad(fs.readFileSync('../_config.yml', 'utf8'))
    existingConfig.prose?= null
    newConfig = _.extend(existingConfig, data)
    content = yaml.dump(newConfig)
    fs.writeFileSync "../_config.yml", content

  process: ->
    data =
      undp_role_type    : _.where @indices, type: 'undp_role_type'
      thematic_focus    : _.where @indices, type: 'thematic_focus'
      territorial_focus : _.where @indices, type: 'territorial_focus'
      scale             : _.where @indices, type: 'scale'
      region            : _.where @indices, type: 'region'
      host_location     : _.where @indices, type: 'country'
      partner_location  : _.where @indices, type: 'country'
      partner_type      : _.where @indices, type: 'partner_type'

    prose:
      rooturl: '_ssc_data'
      metadata:
        _ssc_data:[
          name: 'open_project_id'
          field:
            element: 'text'
            label: 'Project ID from open.undp.org'
        ,
          name: 'project_title'
          field:
            element: 'text'
            label: 'Project title'
        ,
          name: 'project_objective'
          field:
            element: 'textarea'
            label: 'Project objective'
        ,
          name: 'project_link'
          field:
            element: 'text'
            label: 'Project page URL'        
        ,
          name: 'undp_role_type'
          field:
            element: 'multiselect'
            label: 'UNDP engagement type'
            placeholder: 'Choose action'
            options:
              data.undp_role_type
        ,
          name: 'thematic_focus'
          field:
            element: 'multiselect'
            label: 'Thematic Focus'
            placeholder: 'Select area(s) of focus'
            options:
              data.thematic_focus
        ,
          name: 'territorial_focus'
          field:
            element: 'multiselect'
            label: 'Territorial focus'
            placeholder: 'Select area(s) of focus'
            options:
              data.territorial_focus
        ,
          name: 'scale'
          field:
            element: 'select'
            label: 'Scale of operation'
            placeholder: 'National, regional or global'
            options:
              data.scale
        ,
          name: 'region'
          field:
            element: 'multiselect'
            label: 'Region'
            placeholder: 'Select region'
            options: 
              data.region
        ,
          name: 'host_location'
          field:
            element: 'multiselect'
            label: 'Project location (country, etc)'
            placeholder: 'Select location(s)'
            alterable: true
            options:
              data.host_location
        ,
          name: 'partner_type'
          field:
            element: 'multiselect'
            label: 'Partner types'
            options:
              data.partner_type
        # ,
        #   name: 'partner_location'
        #   field:
        #     element: 'multiselect'
        #     label: 'Partner location (country, etc)'
        #     placeholder: 'Select location(s)'
        #     options:
        #       data.partner_location
        ]

new CreateProseConfig
