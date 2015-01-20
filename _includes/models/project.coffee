class Project extends Backbone.Model
  initialize: ->
    id = @get('relative_path').match(/_ssc_data\/(\w{5,15})\..*/)[1]
    @set 'id', id

  allLocations: ->
    _.flatten(@get('host_location'), @get('partner_location'))