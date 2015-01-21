class ProjectFacets
  types: ['location', 'region', 'thematic_focus', 'undp_role_type', 'partner_type']

  constructor: (collection) ->
    @projects = Facetr(collection)
    @addStandardFacets()

  addStandardFacets: ->
    @projects.facet('location')
    @projects.facet('region')
    @projects.facet('thematic_focus')
    @projects.facet('undp_role_type')
    @projects.facet('partner_type')

  facetLists: ->
    regionFacet = facets.filter((i) -> i.data.name == 'region')[0]
