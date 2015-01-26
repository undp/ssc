class Projects extends Backbone.Collection
  types: ['host_location', 'region', 'territorial_focus', 'thematic_focus', 'undp_role_type', 'partner_type']
  url: '{{site.baseurl}}/api/projects.json'
  model: Project

  initialize: ->
    @listenTo @, 'set', @initFacetr

  initFacetr: ->
    @facetr = Facetr(@)
    @addStandardFacets()

  findBySearch: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || i.get('project_objective').match(term)

  addStandardFacets: ->
    _.each @types, (type) =>
      @facetr.facet(type).desc()

  anyFacetSelected: ->
    @selectedFacets().length > 0

  selectedFacets: ->
    _.chain(@facetr.facets())
      .filter( (facet) -> facet.isSelected() )
      .map( (facet) -> facet.toJSON().data.name )
      .value()

  facetFor: (type) ->
    throw 'Facet type not in list' unless _.include(@types, type)
    _.chain(@facetr.toJSON())
      .filter((i) -> i.data.name == type)
      .first()
      .value()