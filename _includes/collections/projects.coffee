API_KEY            = 'h3cXWSFS9SYs4QRcZIOF7qvMJcI4ejKDAN1Gb93W'
APP_ID             = 'vfp0fnij23Dd93CVqlO8fuFpPJIoeOFcE2eslakO'
API_URL            = 'https://api.parse.com/1/classes/stateData'
INITIAL_VIEW_STATE = 'list'

class Projects extends Backbone.Collection

  url: '{{site.baseurl}}/api/projects.json'

  model: Project

  initialize: ->
    @_facetManager ||= new FacetManager(collection: @)

  search: (term) ->
    @filter (i) ->
      i.get('project_title').match(term) || 
      i.get('project_objective').match(term)
