# Retrieve and handle projects from http://open.undp.org

class OpenProject extends Backbone.Model
  initialize: ->
    @set 'edit_link', app.utils.generateEditingUrl(@id)

class OpenProjects extends Backbone.Collection
  model: OpenProject

  url: ->
    year = new Date().getFullYear()
    "http://open.undp.org/api/project_summary_#{year}.json"

  withoutExisting: (existingCollection) =>
    existingOpenIds = _.chain(existingCollection.pluck('open_project_id')).compact().uniq().value()
    _.reject @.toJSON(), (project) ->
      _.include existingOpenIds, project.id

  presentExistingInAdmin: (existingCollection) =>
    existingCollection.map (project) ->
      id: project.get('project_id')
      name: project.get('project_title')
      edit_link: project.get('edit_link')
