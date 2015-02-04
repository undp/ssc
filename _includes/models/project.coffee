class Project extends Backbone.Model
  idAttribute: 'project_id'

  joinedFields: ['host_location', 'undp_role_type', 'thematic_focus', 'territorial_focus', 'partner_location', 'partner_type', 'region']

  initialize: ->
    _.each @joinedFields, (field) =>
      if !_.isArray(@get(field))
        values = @get(field).split(",")
        @set(field, _.map(values, (i) -> 
          s.underscored(i.trim().toLowerCase())
        ))

  allLocations: ->
    _.chain([@get('host_location'), @get('partner_location')])
      .flatten()
      .compact()
      .value()