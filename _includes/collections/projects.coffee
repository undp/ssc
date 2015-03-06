class Projects extends Backbone.Collection

  url: '{{site.baseurl}}/api/projects.json'

  model: Project

  initialize: ->
    _.extend @, ProjectsFacets
    @initializeFacets()

  search: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || 
      i.get('project_objective').match(term)
