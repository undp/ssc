# Retrieve and handle projects from http://open.undp.org

class OpenProject extends Backbone.Model
  initialize: ->
    @set 'edit_link', "http://prose.io/#peoplesized/ssc-dev/edit/gh-pages/_ssc_projects/#{@id}.txt"

class OpenProjects extends Backbone.Collection
  model: OpenProject

  url: ->
    year = new Date().getFullYear()
    "http://open.undp.org/api/project_summary_#{year}.json"

  withoutExisting: (existingCollection) =>
    window.a = @
    window.b = existingCollection
    existingOpenIds = _.chain(existingCollection.pluck('open_project_id')).compact().uniq().value()
    _.reject @.toJSON(), (project) ->
      _.include existingOpenIds, project.id
