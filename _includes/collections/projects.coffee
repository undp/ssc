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

  getLocations: ->
    _.chain(@pluck('host_location'))
      .flatten()
      .uniq()
      .value()

  _projectsForLocation: (location) ->
    return unless location?
    location = location.toLowerCase()

    @filter (project) ->
      _.include(project.get('host_location'), location)