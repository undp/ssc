class Projects extends Backbone.Collection
  model: Project

  findBySearch: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || i.get('project_objective').match(term)

  filterByTheme: (thematic_focus) ->
    @filter (i) ->
      _.include(i.get('thematic_focus'), thematic_focus)

  filterByLocation: (iso3) ->
    @filter (i) ->
        _.include(i.get('host_location'), iso3.toUpperCase())

  filterByPartner: (partner_type) ->
    @filter (i) ->
      _.include(i.get('partner_type'), partner_type)

  filterByRole: (role) ->
    @filter (i) ->
      _.include(i.get('undp_role_type'), role)