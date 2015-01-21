---
---
baseurl = "{{ site.baseurl }}"
app = window.app = {}

# Models and Collections
{% include models/project.coffee %} # Project
{% include models/indice.coffee %} # Indice
{% include models/country.coffee %} # Indice
{% include collections/countries.coffee %} # Countries
{% include collections/projects.coffee %} # Projects
{% include collections/indices.coffee %} # Indices

# Views
{% include views/app-layout.coffee %} # AppLayout
{% include views/project-view.coffee %} # ProjectView
{% include views/explorer-view.coffee %} # ExplorerView
{% include views/search-view.coffee %} # FilterView
{% include views/filter-view.coffee %} # FilterView
{% include views/content-view.coffee %} # ContentView

# Controllers
{% include routers/router.coffee %} # Router
{% include controllers/project-facets.coffee %} # ProjectFacets

$(document).ready ->
  app.projects = new Projects
  app.countries = new Countries(window.countries)
  app.indices = new Indices(window.indices)

  app.projects.fetch
    success: ->
        app.facets = new ProjectFacets(app.projects)
        app.router = new Router()
        Backbone.history.start()