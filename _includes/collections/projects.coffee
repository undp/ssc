class Projects extends Backbone.Collection

  url: '{{site.baseurl}}/api/projects.json'

  model: Project

  initialize: ->
    _.extend @, ProjectsFacets
    @initializeFacets()

  search: (term) ->
    @filter (i) ->
      re = new RegExp(term, 'i')
      re.test(i.get('project_title')) || 
      re.test(i.get('project_objective'))

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