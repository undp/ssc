---
---
baseurl = "{{ site.baseurl }}"

# Models and Collections
{% include models/project.coffee %} # Project
{% include collections/countries.coffee %} # Countries
{% include collections/projects.coffee %} # Projects
{% include collections/connections.coffee %} # Connections

# Views
{% include views/app-layout.coffee %} # AppLayout
{% include views/project-view.coffee %} # ProjectView
{% include views/explorer-view.coffee %} # ExplorerView
{% include views/content-view.coffee %} # ContentView

# Controllers
{% include routers/router.coffee %} # Router

$(document).ready ->
  app = window.app = {}
  app.projects = new Projects
  app.countries = new Countries

  app.projects.fetch
    success: ->
      # app.connections = new Connections(app.projects)
      app.countries.fetch 
        success: ->
          app.router = new Router()
          Backbone.history.start()