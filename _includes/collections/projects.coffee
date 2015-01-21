class Projects extends Backbone.Collection
  url: '{{site.baseurl}}/api/projects.json'
  model: Project

  findBySearch: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || i.get('project_objective').match(term)

