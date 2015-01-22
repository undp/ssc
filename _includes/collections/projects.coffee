class Projects extends Backbone.Collection
  types: ['location', 'region', 'territorial_focus', 'thematic_focus', 'undp_role_type', 'partner_type']
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
    console.log 'addStandardFacets'
    @facetr.facet('location').desc()
    @facetr.facet('region').desc()
    @facetr.facet('thematic_focus').desc()
    @facetr.facet('undp_role_type').desc()
    @facetr.facet('partner_type').desc()

  anyFacetSelected: ->
    @selectedFacets().length > 0

  selectedFacets: ->
    _.chain(@facetr.facets())
      .filter( (facet) -> facet.isSelected() )
      .map( (facet) -> facet.toJSON().data.name )
      .value()
