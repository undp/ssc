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
{% include collections/projects-facets.coffee %} # ProjectsFacets (mixin)

# Controllers and ViewModels
{% include controllers/state-manager.coffee %} # StateManager

# Views
{% include views/project-view.coffee %} # ProjectView
{% include views/explorer-view.coffee %} # ExplorerView
{% include views/search-view.coffee %} # FilterView
{% include views/filter-view.coffee %} # FilterView
{% include views/content-view.coffee %} # ContentView
{% include views/map-view.coffee %} # MapView
{% include views/stats-view.coffee %} # StatsView
{% include views/list-view.coffee %} # ListView
{% include views/controls-view.coffee %} # ControlsView
{% include views/headlines-view.coffee %} # HeadlinesView


# Controllers
{% include routers/router.coffee %} # Router

# Utilities
{% include utils/utils.coffee%}

$(document).ready ->
  # Collections
  app.projects = new Projects
  app.countries = new Countries(preloadData.countries)
  app.filters = new Filters
  app.filters.populate(
    indices: preloadData.indices
    countries: preloadData.countries # TODO: Avoid duplication with above
  )

  app.projects.fetch
    success: (collection) ->
      app.state = new StateManager(observedCollection: collection)
      app.router = new Router()
      Backbone.history.start()
