class Project extends Backbone.Model
  idAttribute: 'project_id'

  joinedFields: ['country', 'undp_role_type', 'thematic_focus', 'territorial_focus', 'partner_type', 'region']

  initialize: ->
    @_addArrayFields()

  _addArrayFields: ->
    _.each @joinedFields, (field) =>
      if !_.isArray(@get(field))
        values = @get(field).split(",")
        @set(field, _.map(values, (i) -> 
          s.underscored(s.trim(i).toLowerCase())
        ))
