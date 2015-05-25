class Projects extends Backbone.Collection

  url: '{{site.baseurl}}/api/projects.json'

  model: Project

  localStorage: new Backbone.LocalStorage("ProjectsCollection")

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

  generateEditNewProjectUrl: ->
    newId = app.utils.newProjectId()
    while @get(newId)
      newId = app.utils.newProjectId()
    app.utils.generateEditingUrl(newId)

  findForIso3: (iso3) ->
    @filter (i) ->
      _.include i.get('country'), iso3