---
---
baseurl = "{{ site.baseurl }}"
app = window.app = {}

# Models and Collections
{% include models/filter.coffee %} # Filter
{% include models/country.coffee %} # Country
{% include models/project.coffee %} # Project
{% include models/present-project.coffee %} # PresentProject
{% include collections/filters.coffee %} # Filters
{% include collections/countries.coffee %} # Countries
{% include collections/projects.coffee %} # Projects

# Views
{% include views/project-view.coffee %} # ProjectView
{% include views/explorer-view.coffee %} # ExplorerView
{% include views/search-view.coffee %} # FilterView
{% include views/filter-view.coffee %} # FilterView
{% include views/content-view.coffee %} # ContentView

# Controllers
{% include routers/router.coffee %} # Router
{% include controllers/project-facets.coffee %} # ProjectFacets
{% include controllers/map.coffee %} # MapController

# Utilities
{% include util/util.coffee%}

$(document).ready ->
  # Collections
  app.projects = new Projects
  app.countries = new Countries(window.countries)
  app.filters = new Filters(window.indices) # To simplify handling of indices 
  app.filters.addCountries()

  # Events
  app.vent = {}; app.vent extends Backbone.Events

  # Map 
  app.mapStyles = {% include data/map_styles.json %}

  app.projects.fetch
    success: ->
      app.projects.initFacetr()
      app.router = new Router()
      Backbone.history.start()

