class Projects extends Backbone.Collection

  url: '{{site.baseurl}}/api/projects.json'

  model: Project

  initialize: ->
    _.extend @, ProjectsFacets
    @initializeFacets()

  search: (term) ->
    @filter (i) ->
      re = new RegExp(term, 'i')
      re.test(i.get('project_title'))

  getLocations: ->
    _.chain(@pluck('country'))
      .flatten()
      .uniq()
      .value()
