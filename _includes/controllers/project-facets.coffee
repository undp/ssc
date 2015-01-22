class ProjectFacets
  types: ['location', 'region', 'territorial_focus', 'thematic_focus', 'undp_role_type', 'partner_type']

  constructor: (collection) ->
    @projects = Facetr(collection)
    @addStandardFacets()

  addStandardFacets: ->
    @projects.facet('location')
    @projects.facet('region')
    @projects.facet('thematic_focus')
    @projects.facet('undp_role_type')
    @projects.facet('partner_type')

  anySelected: ->
    @selected().length > 0

  selected: ->
    _.chain(app.facets.projects.facets())
      .filter( (facet) -> facet.isSelected())
      .map( (facet) -> facet.toJSON().data.name)
      .value()
