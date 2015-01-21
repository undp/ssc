---
---
baseurl = "{{ site.baseurl }}"

# Models and Collections
{% include models/project.coffee %} # Project
{% include collections/countries.coffee %} # Countries
{% include collections/projects.coffee %} # Projects

# Views
{% include views/app-layout.coffee %} # AppLayout
{% include views/project-view.coffee %} # ProjectView
{% include views/explorer-view.coffee %} # ExplorerView
{% include views/filter-view.coffee %} # FilterView
{% include views/content-view.coffee %} # ContentView

# Controllers
{% include routers/router.coffee %} # Router

$(document).ready ->
  app = window.app = {}
  app.projects = new Projects
  app.countries = new Countries

  app.countries.fetch # TODO: Embed somewhere to avoid making request
    success: ->
    app.projects.fetch
      success: ->
          app.faceted = Facetr(app.projects)
          app.router = new Router()
          Backbone.history.start()