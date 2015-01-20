class Project extends Backbone.Model
  idAttribute: 'project_id'

  joinedFields: ['host_location', 'undp_role_type', 'thematic_focus', 'territorial_focus', 'partner_location', 'partner_type']

  initialize: ->
    _.each @joinedFields, (field) =>
      @set(field, @get(field).split(','))
  
  allLocations: ->
    _.flatten(@get('host_location'), @get('partner_location'))